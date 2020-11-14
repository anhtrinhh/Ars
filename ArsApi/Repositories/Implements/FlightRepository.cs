﻿using ArsApi.Contexts;
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
    }
}