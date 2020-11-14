using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface IBookingService
    {
        Task<string> InsertBooking(Booking booking);
        Task<IEnumerable<Booking>> GetBookingByCustomerNo(string customerNo);
    }
}
