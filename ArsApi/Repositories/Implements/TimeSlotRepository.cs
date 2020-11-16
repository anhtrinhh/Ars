using ArsApi.Contexts;
using ArsApi.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Repositories.Implements
{
    public class TimeSlotRepository : ITimeSlotRepository
    {
        private readonly MSSqlContext _db;
        public TimeSlotRepository(MSSqlContext db)
        {
            _db = db;
        }
        public async Task<IEnumerable<TimeSlot>> GetTimeSlotByFlightDirection(string startPointId, string endPointId)
        {
            IEnumerable<TimeSlot> timeSlots = null;
            var parameters = new[]
            {
                new SqlParameter("startPointId", startPointId),
                new SqlParameter("endPointId", endPointId)
            };
            try
            {
                var timeSlotList = await _db.TimeSlot.FromSqlRaw("sp_getTimeSlotByFlightDirection @startPointId, @endPointId", 
                    parameters).ToListAsync();
                if (timeSlotList.Count > 0)
                {
                    timeSlots = timeSlotList;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return timeSlots;
        }
    }
}
