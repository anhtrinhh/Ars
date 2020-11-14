using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ArsApi.Models;
using ArsApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ArsApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class FlightController : ControllerBase
    {
        private readonly IFlightService _service;
        public FlightController(IFlightService service)
        {
            _service = service;
        }
        [HttpGet("search")]
        public async Task<IEnumerable<IEnumerable<Flight>>> SearchFlight(string from, string to, DateTime date1, DateTime? date2 = null) 
        {
            var response = new List<IEnumerable<Flight>>();
            response.Add(await _service.SearchFlight(from, to, date1));
            if(date2 != null)
            {
                response.Add(await _service.SearchFlight(to, from, (DateTime)date2));
            }
            return response;
        }
    }
}
