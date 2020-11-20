using ArsApi.Models;
using ArsApi.Repositories;
using ArsApi.Utils;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class AdminAccountService : IAdminAccountService
    {
        private readonly IConfiguration _config;
        private readonly IAdminAccountRepository _repository;
        public AdminAccountService(IAdminAccountRepository repository, IConfiguration config)
        {
            _repository = repository;
            _config = config;
        }
        public async Task<AdminAccount> CheckSignIn(AdminAccount signin)
        {
            AdminAccount admin = await _repository.GetAdminBySigninInfo(signin.AdminEmail);
            if(admin == null)
            {
                return null;
            }
            if (AppUtils.HashString(signin.AdminPassword, admin.Salt) != admin.AdminPassword)
            {
                return null;
            }
            return admin;
        }

        public async Task<AdminAccount> DeleteAdmin(string adminId)
        {
            return await _repository.DeleteAdmin(adminId);
        }

        public async Task<AdminAccount> EditAdmin(AdminAccount admin)
        {
            return await _repository.EditAdmin(admin);
        }

        public string GenerateJWT(AdminAccount admin)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, admin.AdminId),
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

        public async Task<AdminAccount> GetAdminByAdminId(string adminId)
        {
            return await _repository.GetAdminByAdminId(adminId);
        }

        public async Task<IEnumerable<AdminAccount>> GetAllAdmin()
        {
            return await _repository.GetAllAdmin();
        }

        public async Task<AdminAccount> InsertAdmin(AdminAccount admin)
        {
            string salt = AppUtils.CreateRandomSalt();
            admin.AdminPassword = AppUtils.HashString(admin.AdminPassword, salt);
            admin.AdminId = AppUtils.CreateRandomString(null, 10);
            return await _repository.InsertAdmin(admin);
        }
    }
}
