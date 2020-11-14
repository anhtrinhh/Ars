using ArsApi.Models;
using ArsApi.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class TicketService : ITicketService
    {
        private readonly ITicketRepository _repository;
        private readonly IBookingRepository _bookingRepository;
        public TicketService(ITicketRepository repository, IBookingRepository bookingRepository)
        {
            _repository = repository;
            _bookingRepository = bookingRepository;
        }
        public async Task<bool> InsertTicket(Ticket ticket)
        {
            var success = await _repository.InsertTicket(ticket);
            if(!success)
            {
                await _bookingRepository.DeleteBooking(ticket.BookingId);
            }
            return success;
        }

    }
}
