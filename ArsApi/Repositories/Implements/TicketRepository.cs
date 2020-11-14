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
    public class TicketRepository : ITicketRepository
    {
        private readonly MSSqlContext _db;
        public TicketRepository(MSSqlContext db)
        {
            _db = db;
        }

        public async Task<IEnumerable<Ticket>> GetTicketByBookingId(string bookingId)
        {
            return await _db.Ticket.Where(t => t.BookingId == bookingId).ToListAsync();
        }

        public async Task<bool> InsertTicket(Ticket ticket)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("bookingId", ticket.BookingId),
                new SqlParameter("ticketClassDetailId", ticket.TicketClassDetailId),
                new SqlParameter("ticketClass", ticket.TicketClass),
                new SqlParameter("ticketPrice", ticket.TicketPrice),
                new SqlParameter("guestFirstName", ticket.GuestFirstName),
                new SqlParameter("guestLastName", ticket.GuestLastName),
                new SqlParameter("guestGender", ticket.GuestGender),
                new SqlParameter("guestBirthday", ticket.GuestBirthday)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync(@"sp_insertTicket @bookingId, @ticketClassDetailId, @ticketClass, @ticketPrice, @guestFirstName,
                @guestLastName, @guestGender, @guestBirthday", parameters);
                return true;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
    }
}
