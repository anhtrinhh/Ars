using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ArsApi.Models;
using ArsApi.Services;
using Microsoft.AspNetCore.Authorization;
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
        [HttpGet("search2")]
        public async Task<IEnumerable<IEnumerable<Flight>>> SearchFlight2(string from, string to, DateTime date1, DateTime? date2 = null)
        {
            var response = new List<IEnumerable<Flight>>();
            response.Add(await _service.SearchFlight2(from, to, date1));
            if (date2 != null)
            {
                response.Add(await _service.SearchFlight2(to, from, (DateTime)date2));
            }
            return response;
        }
        [HttpPut("flight-status")]
        public async Task<bool> UpdateFlightStatus()
        {
            string flightStatusStr = HttpContext.Request.Form["flightStatus"];
            bool flightStatus = bool.Parse(flightStatusStr);
            string flightId = HttpContext.Request.Form["flightId"];
            return await _service.UpdateFlightStatus(flightStatus, flightId);
        }

        [HttpGet("{flightId}")]
        public async Task<Flight> GetFlightByFlightId(string flightId)
        {
            return await _service.GetFlightByFlightId(flightId);
        }
        [Authorize]
        [HttpPost]
        public async Task<bool> InsertFlight(Flight flight)
        {
            return await _service.InsertFlight(flight);
        }
    }
}
