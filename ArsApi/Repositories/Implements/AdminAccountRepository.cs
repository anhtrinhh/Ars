using ArsApi.Contexts;
using ArsApi.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories.Implements
{
    public class AdminAccountRepository : IAdminAccountRepository
    {
        private readonly MSSqlContext _db;
        public AdminAccountRepository(MSSqlContext db)
        {
            _db = db;
        }

        public async Task<AdminAccount> GetAdminByAdminId(string adminId)
        {
            return await _db.AdminAccount.FindAsync(adminId);
        }

        public async Task<AdminAccount> GetAdminBySigninInfo(string signin)
        {
            AdminAccount adminAccount = null;
            SqlParameter parameter = new SqlParameter("signin", signin);
            try
            {
                var adminAccounts = await _db.AdminAccount.FromSqlRaw("sp_getAdminBySignInInfo @signin", parameter).ToListAsync();
                if(adminAccounts.Count > 0)
                {
                    adminAccount = new AdminAccount();
                    foreach (var admin in adminAccounts)
                    {
                        adminAccount = admin;
                        break;
                    }
                }
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return adminAccount;
        }
    }
}
