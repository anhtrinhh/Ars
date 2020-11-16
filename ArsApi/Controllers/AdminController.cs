using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using ArsApi.Models;
using ArsApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ArsApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly IAdminAccountService _service;
        public AdminController(IAdminAccountService service)
        {
            _service = service;
        }
        [HttpPost("signin")]
        public async Task<IActionResult> SignIn(AdminAccount admin)
        {
            IActionResult response = Unauthorized();
            var adminAccount = await _service.CheckSignIn(admin);
            if (adminAccount != null)
            {
                var tokenStr = _service.GenerateJWT(adminAccount);
                response = Ok(new
                {
                    token = tokenStr
                });
            }
            return response;
        }
        [Authorize]
        [HttpGet("getadmin")]
        public async Task<IActionResult> getAdmin()
        {
            IActionResult response = Unauthorized();
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            var adminId = claims[0].Value;
            AdminAccount admin = await _service.GetAdminByAdminId(adminId);
            if(admin != null)
            {
                response = Ok(new
                {
                    admin.AdminFirstName,
                    admin.AdminLastName,
                    admin.AdminAvatar,
                    admin.AdminEmail,
                    admin.AdminPhoneNumber,
                    admin.AdminGender,
                    admin.AdminBirthday
                });
            }
            return response;
        }
    }
}
