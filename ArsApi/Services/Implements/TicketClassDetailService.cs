using ArsApi.Models;
using ArsApi.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class TicketClassDetailService : ITicketClassDetailService
    {
        private readonly ITicketClassDetailRepository _repository;
        public TicketClassDetailService(ITicketClassDetailRepository repository)
        {
            _repository = repository;
        }
        public async Task<bool> InsertTicketClassDetail(TicketClassDetail ticketClassDetail)
        {
            return await _repository.InsertTicketClassDetail(ticketClassDetail);
        }
    }
}
