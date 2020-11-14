using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using ArsApi.Models;
using ArsApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace ArsApi.Controllers
{
    [Route("[controller]/[action]")]
    [ApiController]
    public class CustomerAccountController : ControllerBase
    {
        private readonly ICustomerService _service;
        public CustomerAccountController(ICustomerService service)
        {
            _service = service;
        }

        [HttpPost]
        public async Task<IActionResult> SignIn(CustomerAccount cus )
        {
            IActionResult response = Unauthorized();
            var customer = await _service.CheckSignIn(cus);
            if(customer != null)
            {
                var tokenStr = _service.GenerateJWT(customer);
                response = Ok(new { 
                    token = tokenStr
                });
            }
            return response;
        }

        [HttpPost]
        public async Task<bool> SignUp(CustomerAccount customer)
        {
            return await _service.SignUp(customer);
        }
        [HttpPost("{customerNoHashed}")]
        public async Task<bool> ActiveAccount(string customerNoHashed, CustomerAccount customer)
        {
            return await _service.ActiveAccount(customer.CustomerNo, customer.CustomerPassword, customerNoHashed);
        }
        
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetCustomer()
        {
            IActionResult response = Unauthorized();
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            var customerNo = claims[0].Value;
            CustomerAccount customer = await _service.GetCustomerByCustomerNo(customerNo);
            if(customer != null)
            {
                response = Ok(new
                {
                    customer.CustomerNo,
                    customer.CustomerFirstName,
                    customer.CustomerLastName,
                    customer.CustomerEmail,
                    customer.CustomerBirthday,
                    customer.CustomerPhoneNumber,
                    customer.CustomerAddress,
                    customer.CustomerAvatar,
                    customer.CustomerIdentification,
                    customer.CustomerGender
                });
            }
            return response;
        }

        [Authorize]
        [HttpPut]
        public async Task<CustomerAccount> UpdateCustomerBasicInfo(CustomerAccount customer)
        {
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            customer.CustomerNo = claims[0].Value;
            return await _service.UpdateCustomerBasicInfo(customer); 
        }
        [Authorize]
        [HttpPut]
        public async Task<CustomerAccount> UpdateCustomerContactInfo(CustomerAccount customer)
        {
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            customer.CustomerNo = claims[0].Value;
            return await _service.UpdateCustomerContactInfo(customer);
        }
        [Authorize]
        [HttpPut]
        public async Task<string> UpdateCustomerAvatar(IFormFile pictureFile)
        {
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            string customerNo = claims[0].Value;
            return await _service.UpdateCustomerAvatar(customerNo, pictureFile);
        }
        [Authorize]
        [HttpPut]
        public async Task<bool> UpdateCustomerPassword()
        {
            string customerPassword = HttpContext.Request.Form["customerPassword"];
            string currentPassword = HttpContext.Request.Form["currentPassword"];
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            string customerNo = claims[0].Value;
            return await _service.ChangeCustomerPassword(customerNo, customerPassword, currentPassword);
        }
    }
}
