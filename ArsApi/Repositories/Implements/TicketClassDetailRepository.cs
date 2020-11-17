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

        public async Task<bool> InsertTicketClassDetail(TicketClassDetail ticketClassDetail)
        {
            var parameters = new[]
            {
                new SqlParameter("ticketClassId", ticketClassDetail.TicketClassId),
                new SqlParameter("flightId", ticketClassDetail.FlightId),
                new SqlParameter("adultTicketPrice", ticketClassDetail.AdultTicketPrice),
                new SqlParameter("childTicketPrice", ticketClassDetail.ChildTicketPrice),
                new SqlParameter("infantTicketPrice", ticketClassDetail.InfantTicketPrice),
                new SqlParameter("adultTex", ticketClassDetail.AdultTex),
                new SqlParameter("childTex", ticketClassDetail.ChildTex),
                new SqlParameter("infantTex", ticketClassDetail.InfantTex),
                new SqlParameter("numberTicket", ticketClassDetail.NumberTicket)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_insertTicketClassDetail @ticketClassId, @flightId, @adultTicketPrice," +
                    "@childTicketPrice, @infantTicketPrice, @adultTex, @childTex, @infantTex, @numberTicket", parameters);
                return true;
            } catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
    }
}
