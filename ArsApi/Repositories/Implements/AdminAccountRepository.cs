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

        public async Task<AdminAccount> DeleteAdmin(string adminId)
        {
            var admin = await _db.AdminAccount.FindAsync(adminId);
            if (admin == null)
            {
                return null;
            }
            _db.AdminAccount.Remove(admin);
            await _db.SaveChangesAsync();
            return admin;
        }

        public async Task<AdminAccount> EditAdmin(AdminAccount admin)
        {
            var adminAcc = await _db.AdminAccount.FindAsync(admin.AdminId);
            if (adminAcc == null)
            {
                return null;
            }
            var parameters = new SqlParameter[]
            {
                new SqlParameter("adminId", admin.AdminId),
                new SqlParameter("adminFirstName", admin.AdminFirstName),
                new SqlParameter("adminLastName", admin.AdminLastName),
                new SqlParameter("adminBirthday", admin.AdminBirthday),
                new SqlParameter("adminGender", admin.AdminGender),
                new SqlParameter("adminRights", admin.AdminRights)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateAdmin @adminId, @adminFirstName, @adminLastName, @adminBirthday, @adminGender, @adminRights", parameters);
                return adminAcc;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return null;
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
                if (adminAccounts.Count > 0)
                {
                    adminAccount = new AdminAccount();
                    foreach (var admin in adminAccounts)
                    {
                        adminAccount = admin;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return adminAccount;
        }

        public async Task<IEnumerable<AdminAccount>> GetAllAdmin()
        {
            IEnumerable<AdminAccount> accounts = null;
            try
            {
               accounts = await _db.AdminAccount.FromSqlRaw("sp_getAllAdmin").ToListAsync();
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return accounts;
         }

        public async Task<AdminAccount> InsertAdmin(AdminAccount admin)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("adminId", admin.AdminId),
                new SqlParameter("creatorId", admin.CreatorId),
                new SqlParameter("adminFirstName", admin.AdminFirstName),
                new SqlParameter("adminLastName", admin.AdminLastName),
                new SqlParameter("adminEmail", admin.AdminEmail),
                new SqlParameter("adminPhoneNumber", admin.AdminPhoneNumber),
                new SqlParameter("adminPassword", admin.AdminPassword),
                new SqlParameter("salt", admin.Salt),
                new SqlParameter("adminBirthday", admin.AdminBirthday),
                new SqlParameter("adminGender", admin.AdminGender),
                new SqlParameter("adminRights", admin.AdminRights)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_insertAdmin @adminId,@creatorId, @adminFirstName, @adminLastName, " +
                    "@adminEmail, @adminPhoneNumber, @adminPassword, @salt, @adminBirthday, @adminGender,@adminRights", parameters);
                return admin;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return null;
        }
    }
}
