using ArsApi.Models;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface ICustomerService
    {
        Task<bool> SignUp(CustomerAccount customer);
        Task<bool> UpdateCustomerPassword(string customerNo, string password);
        Task<bool> ActiveAccount(string customerNo, string customerPassword, string customerNoParam);
        Task<CustomerAccount> CheckSignIn(CustomerAccount signin);
        string GenerateJWT(CustomerAccount customer);
        Task<CustomerAccount> GetCustomerByCustomerNo(string customerNo);
        Task<CustomerAccount> UpdateCustomerContactInfo(CustomerAccount customer);
        Task<CustomerAccount> UpdateCustomerBasicInfo(CustomerAccount customer);
        Task<string> UpdateCustomerAvatar(string customerNo, IFormFile avatarFile);
        Task<bool> ChangeCustomerPassword(string customerNo, string customerPassword, string currentPassword);
    }
}
