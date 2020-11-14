using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface ITicketService
    {
        Task<bool> InsertTicket(Ticket ticket);
    }
}
