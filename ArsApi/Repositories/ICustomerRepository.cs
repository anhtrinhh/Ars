using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface ICustomerRepository
    {
        Task<bool> InsertCustomer(CustomerAccount customer);
        Task<CustomerAccount> GetCustomerBySignInInfo(string signin);
        Task<CustomerAccount> GetCustomerByCustomerNo(string customerNo);
        Task<bool> UpdateCustomerPassword(string customerNo, string customerPassword, string salt);
        Task<bool> UpdateCustomerEmailToken(string customerNo, string emailToken);
        Task<bool> UpdateCustomerAvatar(string customerNo, string customerAvatar);
        Task<bool> DeleteCustomer(string customerNo);
        Task<CustomerAccount> UpdateCustomerBasicInfo(CustomerAccount customer);
        Task<CustomerAccount> UpdateCustomerContactInfo(CustomerAccount customer);
    }
}
