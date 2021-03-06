﻿using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface IFlightRepository
    {
        Task<IEnumerable<Flight>> GetFlightBySearchData(string startPointId, string endPointId, DateTime flightDate);
        Task<IEnumerable<Flight>> GetFlightBySearchData2(string startPointId, string endPointId, DateTime flightDate);
        Task<bool> InsertFlight(Flight flight);
        Task<Flight> GetFlightByFlightId(string flightId);
        Task<bool> UpdateFlightStatus(bool flightStatus, string flightId);
    }
}
