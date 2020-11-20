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
        Task<IEnumerable<AdminAccount>> GetAllAdmin();
        Task<AdminAccount> InsertAdmin(AdminAccount admin);

        Task<AdminAccount> DeleteAdmin(string adminId);

        Task<AdminAccount> EditAdmin(AdminAccount admin);
    }
}
