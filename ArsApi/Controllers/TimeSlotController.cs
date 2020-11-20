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
        [HttpGet("{startPointId}/{endPointId}")]
        public async Task<IEnumerable<TimeSlot>> GetTimeSlotByFlightDirection(string startPointId, string endPointId)
        {
            if (!string.IsNullOrEmpty(startPointId) && !string.IsNullOrEmpty(endPointId))
            {
                return await _service.GetTimeSlotByFlightDirection(startPointId, endPointId);
            }
            return new List<TimeSlot>();
        }
        [HttpPost]
        public async Task<bool> Insert()
        {
            string startTime = HttpContext.Request.Form["startTime"];
            string endTime = HttpContext.Request.Form["endTime"];
            string startPointId = HttpContext.Request.Form["startPointId"];
            string endPointId = HttpContext.Request.Form["endPointId"];
            return await _service.InsertTimeSlot(startTime, endTime, startPointId, endPointId);
        }
        [HttpPut]
        public async Task<bool> Update()
        {
            string startTime = HttpContext.Request.Form["startTime"];
            string endTime = HttpContext.Request.Form["endTime"];
            string startPointId = HttpContext.Request.Form["startPointId"];
            string endPointId = HttpContext.Request.Form["endPointId"];
            string timeSlotIdStr = HttpContext.Request.Form["timeSlotId"];
            int timeSlotId = int.Parse(timeSlotIdStr);
            return await _service.UpdateTimeSlot(timeSlotId, startTime, endTime, startPointId, endPointId);
        }
        [HttpDelete("{timeSlotId}")]
        public async Task<bool> Delete(int timeSlotId) 
        {
            return await _service.DeleteTimeSlot(timeSlotId);
        }
    }
}
