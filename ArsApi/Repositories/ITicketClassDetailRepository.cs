using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface ITicketClassDetailRepository
    {
        Task<IEnumerable<TicketClassDetail>> GetTicketClassDetailsByFlightId(string flightId);
    }
}
