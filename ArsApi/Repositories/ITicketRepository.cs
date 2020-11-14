using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface ITicketRepository
    {
        Task<bool> InsertTicket(Ticket ticket);
        Task<IEnumerable<Ticket>> GetTicketByBookingId(string bookingId);
    }
}
