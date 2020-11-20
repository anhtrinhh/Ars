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

        public async Task<bool> DeleteTimeSlot(int timeSlotId)
        {
           TimeSlot ts = await _db.TimeSlot.FindAsync(timeSlotId);
            if(ts == null)
            {
                return false;
            }
            _db.TimeSlot.Remove(ts);
            await _db.SaveChangesAsync();
            return true;
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

        public async Task<bool> InsertTimeSlot(string startTime, string endTime, string startPointId, string endPointId)
        {
            var parameters = new[]
            {
                new SqlParameter("startTime", startTime),
                new SqlParameter("endTime", endTime),
                new SqlParameter("startPointId", startPointId),
                new SqlParameter("endPointId", endPointId)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_insertTimeSlot @startTime, @endTime, @startPointId, @endPointId", parameters);
                return true;
            }catch(Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }

        public async Task<bool> UpdateTimeSlot(int timeSlotId, string startTime, string endTime, string startPointId, string endPointId)
        {
            var parameters = new[]
            {
                new SqlParameter("timeSlotId", timeSlotId),
                new SqlParameter("startTime", startTime),
                new SqlParameter("endTime", endTime),
                new SqlParameter("startPointId", startPointId),
                new SqlParameter("endPointId", endPointId)
            };
            try
            {
                await _db.Database.ExecuteSqlRawAsync("sp_updateTimeSlot @timeSlotId, @startTime, @endTime, @startPointId, @endPointId", parameters);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return false;
        }
    }
}
