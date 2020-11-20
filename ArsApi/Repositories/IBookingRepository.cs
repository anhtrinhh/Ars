using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface IBookingRepository
    {
        Task<bool> InsertBooking(Booking booking);
        Task<bool> DeleteBooking(string bookingId);

        Task<IEnumerable<Booking>> GetBookingByCustomerNo(string customerNo);
        Task<IEnumerable<Booking>> GetBookingByFlightId(string flightId);

    }
}
