using ArsApi.Models;
using ArsApi.Repositories;
using ArsApi.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class BookingService : IBookingService
    {
        private readonly IBookingRepository _repository;
        public BookingService(IBookingRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<Booking>> GetBookingByCustomerNo(string customerNo)
        {
            return await _repository.GetBookingByCustomerNo(customerNo);
        }
        public async Task<IEnumerable<Booking>> GetBookingByFlightId(string flightId)
        {
            return await _repository.GetBookingByFlightId(flightId);
        }
        public async Task<string> InsertBooking(Booking booking)
        {
            booking.BookingId = AppUtils.CreateRandomString("B", 9);
            bool success = false;
            for(var i = 0; i < 5; i++)
            {
                success = await _repository.InsertBooking(booking);
                if(success)
                {
                    break;
                }
            }
            if(success)
            {
                return booking.BookingId;
            }
            return null;
        }
    }
}
