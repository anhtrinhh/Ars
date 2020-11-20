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
        [HttpPost]
        public async Task<AdminAccount> Post(AdminAccount admin)
        {
            return await _service.InsertAdmin(admin);
        }
        [HttpGet]
        public async Task<IEnumerable<AdminAccount>> Get()
        {
            return await _service.GetAllAdmin();
        }
        [HttpPut]
        public async Task<AdminAccount> Put(AdminAccount admin)
        {
            return await _service.EditAdmin(admin);
        }
        [HttpDelete]
        public async Task<AdminAccount> Delete(string adminId)
        {
            return await _service.DeleteAdmin(adminId);
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
                    admin.AdminBirthday,
                    admin.AdminRights
                });
            }
            return response;
        }
    }
}
