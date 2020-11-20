using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface IFlightService
    {
        Task<IEnumerable<Flight>> SearchFlight(string startPointId, string endPointId, DateTime flightDate);
        Task<IEnumerable<Flight>> SearchFlight2(string startPointId, string endPointId, DateTime flightDate);
        Task<bool> InsertFlight(Flight flight);
        Task<Flight> GetFlightByFlightId(string flightId);
        Task<bool> UpdateFlightStatus(bool flightStatus, string flightId);
    }
}
