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
    public class TicketClassDetailRepository : ITicketClassDetailRepository
    {
        private readonly MSSqlContext _db;
        public TicketClassDetailRepository(MSSqlContext db)
        {
            _db = db ?? throw new ArgumentNullException(nameof(db));
        }
        public async Task<IEnumerable<TicketClassDetail>> GetTicketClassDetailsByFlightId(string flightId)
        {
            SqlParameter parameter = new SqlParameter("flightId", flightId);
            try
            {
                var ticketClassDetails = await _db.TicketClassDetail.FromSqlRaw("sp_getTicketClassDetailsByFlightId @flightId", parameter).ToListAsync();
                return ticketClassDetails;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return null;
        }
    }
}
