using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface IMailService
    {
        Task<bool> SendEmail(string email, string subject, string message);
    }
}
