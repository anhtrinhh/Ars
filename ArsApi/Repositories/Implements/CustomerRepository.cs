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
    public class CustomerRepository : ICustomerRepository
    {
        private readonly MSSqlContext _db;
        public CustomerRepository(MSSqlContext db)
        {
            _db = db ?? throw new ArgumentNullException(nameof(db));
        }

        public async Task<CustomerAccount> GetCustomerBySignInInfo(string signin)
        {
            CustomerAccount customer = null;
            SqlParameter parameter = new SqlParameter("signin", signin);
            try
            {
                var customerList = await _db.CustomerAccount.FromSqlRaw("sp_getCustomerBySignInInfo @signin", parameter).ToListAsync();
                if (customerList.Count > 0)
                {
                    customer = new CustomerAccount();
                    foreach (var cus in customerList)
                    {
                        customer = cus;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return customer;
        }

        public async Task<bool> InsertCustomer(CustomerAccount customer)
        {
            IEnumerable<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("customerNo", customer.CustomerNo),
                new SqlParameter("customerFirstName", customer.CustomerFirstName),
                new SqlParameter("customerLastName", customer.CustomerLastName),
                new SqlParameter("customerEmail", customer.CustomerEmail),
                new SqlParameter("customerPhoneNumber", customer.CustomerPhoneNumber),
                new SqlParameter("customerGender", customer.CustomerGender),
                new SqlParameter("customerBirthday", customer.CustomerBirthday),
                new SqlParameter("customerIdentification", customer.CustomerIdentification),
                new SqlParameter("customerAddress", customer.CustomerAddress)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_insertCustomer @customerNo, @customerFirstName, @customerLastName, " +
                    "@customerEmail, @customerPhoneNumber, @customerGender, " +
                    "@customerBirthday, @customerIdentification, @customerAddress", parameters);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
        public async Task<bool> UpdateCustomerPassword(string customerNo, string customerPassword, string salt)
        {
            IEnumerable<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("customerNo",customerNo),
                new SqlParameter("customerPassword",customerPassword),
                new SqlParameter("salt", salt)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateCustomerPassword @customerNo, @customerPassword, @salt", parameters);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
        public async Task<bool> UpdateCustomerEmailToken(string customerNo, string emailToken)
        {
            IEnumerable<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("customerNo",customerNo),
                new SqlParameter("emailToken", emailToken)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateCustomerEmailToken @customerNo, @emailToken", parameters);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
        public async Task<bool> UpdateCustomerAvatar(string customerNo, string customerAvatar)
        {
            IEnumerable<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("customerNo",customerNo),
                new SqlParameter("customerAvatar", customerAvatar)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateCustomerAvatar @customerNo, @customerAvatar", parameters);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
        public async Task<bool> DeleteCustomer(string customerNo)
        {
            SqlParameter parameter = new SqlParameter("customerNo", customerNo);
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_deleteCustomer @customerNo", parameter);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
        public async Task<CustomerAccount> GetCustomerByCustomerNo(string customerNo)
        {
            CustomerAccount customer = null;
            SqlParameter parameter = new SqlParameter("customerNo", customerNo);
            try
            {
                var customerList = await _db.CustomerAccount.FromSqlRaw("sp_getCustomerByCustomerNo @customerNo", parameter).ToListAsync();
                if (customerList.Count > 0)
                {
                    customer = new CustomerAccount();
                    foreach (var cus in customerList)
                    {
                        customer = cus;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return customer;
        }

        public async Task<CustomerAccount> UpdateCustomerBasicInfo(CustomerAccount customer)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("customerNo", customer.CustomerNo),
                new SqlParameter("customerFirstName", customer.CustomerFirstName),
                new SqlParameter("customerLastName", customer.CustomerLastName),
                new SqlParameter("customerBirthday", customer.CustomerBirthday),
                new SqlParameter("customerGender", customer.CustomerGender)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateCustomerBasicInfo @customerNo, @customerFirstName, " +
                    "@customerLastName, @customerBirthday, @customerGender", parameters);
                return new CustomerAccount
                {
                    CustomerFirstName = customer.CustomerFirstName,
                    CustomerLastName = customer.CustomerLastName,
                    CustomerBirthday = customer.CustomerBirthday,
                    CustomerGender = customer.CustomerGender
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return null;
        }

        public async Task<CustomerAccount> UpdateCustomerContactInfo(CustomerAccount customer)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("customerNo", customer.CustomerNo),
                new SqlParameter("customerPhoneNumber", customer.CustomerPhoneNumber),
                new SqlParameter("customerIdentification", customer.CustomerIdentification),
                new SqlParameter("customerAddress", customer.CustomerAddress)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateCustomerContactInfo @customerNo, " +
                    "@customerPhoneNumber, @customerIdentification, @customerAddress", parameters);
                return new CustomerAccount
                {
                    CustomerPhoneNumber = customer.CustomerPhoneNumber,
                    CustomerIdentification = customer.CustomerIdentification,
                    CustomerAddress = customer.CustomerAddress
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return null;
        }
    }
}
