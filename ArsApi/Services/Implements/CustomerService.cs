using ArsApi.Models;
using ArsApi.Repositories;
using ArsApi.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Security.Claims;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _repository;
        private readonly IMailService _mailService;
        private readonly IConfiguration _config;
        public CustomerService(ICustomerRepository repository, IMailService mailService, IConfiguration config)
        {
            _repository = repository;
            _mailService = mailService;
            _config = config;
        }
        public async Task<CustomerAccount> GetCustomerByCustomerNo(string customerNo)
        {
            CustomerAccount customer = null;
            if (customerNo == null)
            {
                return customer;
            }
            customer = await _repository.GetCustomerByCustomerNo(customerNo);
            return customer;
        }

        public async Task<CustomerAccount> UpdateCustomerContactInfo(CustomerAccount customer)
        {
            return await _repository.UpdateCustomerContactInfo(customer);
        }
        public async Task<bool> SignUp(CustomerAccount customer)
        {
            string emailRegex = "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?!-)(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$";
            string phoneRegex = "^\\d{8,15}$";
            if (customer == null)
            {
                return false;
            }
            if (customer.CustomerFirstName.Length <= 0 || customer.CustomerLastName.Length <= 0 || customer.CustomerEmail.Length <= 0
              || (customer.CustomerPhoneNumber.Length < 8 && customer.CustomerPhoneNumber.Length > 15)
              || customer.CustomerIdentification.Length < 8 || customer.CustomerAddress.Length < 3)
            {
                return false;
            }
            if (!Regex.IsMatch(customer.CustomerEmail, emailRegex))
            {
                return false;
            }
            if (!Regex.IsMatch(customer.CustomerPhoneNumber, phoneRegex))
            {
                return false;
            }
            bool sendMail = false;
            for (int i = 0; i < 5; i++)
            {
                customer.CustomerNo = AppUtils.CreateRandomString(null, 11);
                bool success = await _repository.InsertCustomer(customer);
                if (success)
                {
                    string mailContent = AppUtils.CreateEmailActiveAccount(customer.CustomerFirstName + " "
                        + customer.CustomerLastName, customer.CustomerNo,
                        Regex.Replace(AppUtils.HashString(customer.CustomerNo), "\\W+", ""));
                    sendMail = await _mailService.SendEmail(customer.CustomerEmail, "Welcome to ARS Airways", mailContent);
                    break;
                }
            }
            if (sendMail)
            {
                return true;
            }
            else
            {
                await _repository.DeleteCustomer(customer.CustomerNo);
            }
            return false;
        }
        public async Task<bool> ActiveAccount(string customerNo, string customerPassword, string customerNoParam)
        {
            string base64Str = Regex.Replace(AppUtils.HashString(customerNo), "\\W+", "");
            if (base64Str != customerNoParam)
            {
                return false;
            }
            CustomerAccount customer = await _repository.GetCustomerByCustomerNo(customerNo);
            if (customer == null)
            {
                return false;
            }
            if (!string.IsNullOrEmpty(customer.CustomerPassword))
            {
                return false;
            }
            bool success = await UpdateCustomerPassword(customerNo, customerPassword);
            return success;
        }
        public async Task<bool> UpdateCustomerPassword(string customerNo, string customerPassword)
        {
            string salt = AppUtils.CreateRandomSalt();
            customerPassword = AppUtils.HashString(customerPassword, salt);
            bool success = await _repository.UpdateCustomerPassword(customerNo, customerPassword, salt);
            if (success)
            {
                return true;
            }
            return false;
        }
        public async Task<bool> ChangeCustomerPassword(string customerNo, string customerPassword, string currentPassword)
        {
            var customer = await GetCustomerByCustomerNo(customerNo);
            string hashCurrentPassword = AppUtils.HashString(currentPassword, customer.Salt);
            if (customer.CustomerPassword != hashCurrentPassword)
            {
                return false;
            }
            string salt = AppUtils.CreateRandomSalt();
            customerPassword = AppUtils.HashString(customerPassword, salt);
            bool success = await _repository.UpdateCustomerPassword(customerNo, customerPassword, salt);
            if (success)
            {
                return true;
            }
            return false;
        }
        public async Task<CustomerAccount> CheckSignIn(CustomerAccount signin)
        {
            CustomerAccount customer = await _repository.GetCustomerBySignInInfo(signin.CustomerEmail);
            if (customer == null)
            {
                return null;
            }
            if (AppUtils.HashString(signin.CustomerPassword, customer.Salt) != customer.CustomerPassword)
            {
                return null;
            }
            return customer;
        }
        public string GenerateJWT(CustomerAccount customer)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, customer.CustomerNo),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };
            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Issuer"],
                claims,
                expires: DateTime.Now.AddDays(3),
                signingCredentials: credentials);
            var encodeToken = new JwtSecurityTokenHandler().WriteToken(token);
            return encodeToken;
        }

        public async Task<CustomerAccount> UpdateCustomerBasicInfo(CustomerAccount customer)
        {
            return await _repository.UpdateCustomerBasicInfo(customer);
        }

        public async Task<string> UpdateCustomerAvatar(string customerNo, IFormFile pictureFile)
        {
            if (pictureFile != null)
            {
                if (pictureFile.Length > 0)
                {
                    var uploadPath = "wwwroot/upload/customer/";
                    var fileName = Regex.Replace(AppUtils.HashString(customerNo), "\\W+", "") + ".png";
                    var success = await _repository.UpdateCustomerAvatar(customerNo, fileName);
                    if (success)
                    {
                        if (!Directory.Exists(uploadPath))
                        {
                            Directory.CreateDirectory(uploadPath);
                        }
                        try
                        {
                            using (var stream = new FileStream(uploadPath + fileName, FileMode.Create))
                            {
                                await pictureFile.CopyToAsync(stream);
                            }
                            return fileName;
                        }
                        catch (Exception exp)
                        {
                            throw exp;
                        }
                    }
                }
            }
            return null;
        }
    }
}
