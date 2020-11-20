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
    public class FlightRepository : IFlightRepository
    {
        private readonly MSSqlContext _db;
        public FlightRepository(MSSqlContext db)
        {
            _db = db ?? throw new ArgumentNullException(nameof(db));
        }

        public async Task<Flight> GetFlightByFlightId(string flightId)
        {
            return await _db.Flight.FindAsync(flightId);
        }

        public async Task<IEnumerable<Flight>> GetFlightBySearchData(string startPointId, string endPointId, DateTime flightDate)
        {
            var parameters = new SqlParameter[]
            {
                new SqlParameter("startPointId", startPointId),
                new SqlParameter("endPointId", endPointId),
                new SqlParameter("flightDate", flightDate)
            };
            try
            {
                var flights = await _db.Flight.FromSqlRaw("sp_searchFlights @startPointId, @endPointId, @flightDate", parameters).ToListAsync();
                if(flights.Count > 0)
                {
                    return flights;
                }
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return null;
        }

        public async Task<IEnumerable<Flight>> GetFlightBySearchData2(string startPointId, string endPointId, DateTime flightDate)
        {
            var flights = _db.Flight.Where(f => f.StartPointId == startPointId && f.EndPointId == endPointId && f.FlightDate == flightDate);
            return await flights.ToListAsync();

        }

        public async Task<bool> InsertFlight(Flight flight)
        {
            var parameters = new[]
            {
                new SqlParameter("flightId", flight.FlightId),
                new SqlParameter("startPointId", flight.StartPointId),
                new SqlParameter("endPointId", flight.EndPointId),
                new SqlParameter("flightDate", flight.FlightDate),
                new SqlParameter("startTime", flight.StartTimeStr),
                new SqlParameter("endTime", flight.EndTimeStr),
                new SqlParameter("flightNote", flight.FlightNote ?? (object) DBNull.Value)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_insertFlight @flightId, @startPointId, @endPointId, @flightDate," +
                    "@startTime, @endTime, @flightNote", parameters);
                return true;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }

        public async Task<bool> UpdateFlightStatus(bool flightStatus, string flightId)
        {
            var parameters = new[]
            {
                new SqlParameter("flightStatus", flightStatus),
                new SqlParameter("flightId", flightId)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateFlightStatus @flightStatus, @flightId", parameters);
                return true;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
    }
}
