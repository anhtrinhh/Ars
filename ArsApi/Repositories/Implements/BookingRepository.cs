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
    public class BookingRepository : IBookingRepository
    {
        private readonly MSSqlContext _db;
        public BookingRepository(MSSqlContext db)
        {
            _db = db;
        }

        public async Task<bool> DeleteBooking(string bookingId)
        {
            if (string.IsNullOrEmpty(bookingId))
            {
                return false;
            }
            var booking = await _db.Booking.FindAsync(bookingId);
            if (booking == null)
            {
                return false;
            }
            _db.Booking.Remove(booking);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<Booking>> GetBookingByCustomerNo(string customerNo)
        {
            var bookings =  _db.Booking.Where(b => b.CustomerNo == customerNo)
                             .Include(b => b.Flight)
                             .Include(b => b.Ticket)
                             .OrderByDescending(b => b.CreatedAt);
            return await bookings.ToListAsync();

        }

        public async Task<bool> InsertBooking(Booking booking)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("bookingId", booking.BookingId),
                new SqlParameter("numberAdults", booking.NumberAdults),
                new SqlParameter("numberChildren", booking.NumberChildren),
                new SqlParameter("numberInfants", booking.NumberInfants),
                new SqlParameter("totalTex", booking.TotalTex),
                new SqlParameter("totalTicketPrice", booking.TotalTicketPrice),
                new SqlParameter("customerNo", booking.CustomerNo),
                new SqlParameter("flightId", booking.FlightId)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync(@"sp_insertBooking @bookingId, @numberAdults, @numberChildren, 
                @numberInfants, @totalTex, @totalTicketPrice, @customerNo, @flightId", parameters);
                return true;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
    }
}
