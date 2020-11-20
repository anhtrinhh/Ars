using ArsApi.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories
{
    public interface ITimeSlotRepository
    {
        Task<IEnumerable<TimeSlot>> GetTimeSlotByFlightDirection(string startPointId, string endPointId);
        Task<bool> InsertTimeSlot(string startTime, string endTime, string startPointId, string endPointId);
        Task<bool> UpdateTimeSlot(int timeSlotId, string startTime, string endTime, string startPointId, string endPointId);

        Task<bool> DeleteTimeSlot(int timeSlotId);
    }
}
