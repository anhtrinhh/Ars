using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services
{
    public interface ITimeSlotService
    {
        Task<IEnumerable<TimeSlot>> GetRestTimeSlotOfFlight(string startPointId, string endPointId, DateTime flightDate);
    }
}
