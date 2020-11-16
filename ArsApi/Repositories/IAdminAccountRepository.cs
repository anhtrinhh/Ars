using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface IAdminAccountRepository
    {
        Task<AdminAccount> GetAdminBySigninInfo(string signin);
        Task<AdminAccount> GetAdminByAdminId(string adminId);
    }
}
