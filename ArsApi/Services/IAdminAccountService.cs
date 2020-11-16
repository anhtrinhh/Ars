using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface IAdminAccountService
    {
        Task<AdminAccount> CheckSignIn(AdminAccount signin);
        string GenerateJWT(AdminAccount admin);
        Task<AdminAccount> GetAdminByAdminId(string adminId);
    }
}
