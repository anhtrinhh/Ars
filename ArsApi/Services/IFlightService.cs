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
    }
}
