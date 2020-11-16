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
    public class TimeSlotController : ControllerBase
    {
        private readonly ITimeSlotService _service;
        public TimeSlotController(ITimeSlotService service)
        {
            _service = service;
        }
        [Authorize]
        [HttpGet("rest/{startPointId}/{endPointId}/{flightDate}")]
        public async Task<IEnumerable<TimeSlot>> Rest(string startPointId, string endPointId, DateTime? flightDate)
        {
            if(!string.IsNullOrEmpty(startPointId) && !string.IsNullOrEmpty(endPointId) && flightDate != null)
            {
                return await _service.GetRestTimeSlotOfFlight(startPointId, endPointId, (DateTime)flightDate);
            }
            return new List<TimeSlot>();
        }
    }
}
