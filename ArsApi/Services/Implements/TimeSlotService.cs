using ArsApi.Models;
using ArsApi.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class TimeSlotService : ITimeSlotService
    {
        private readonly ITimeSlotRepository _repository;
        private readonly IFlightRepository _flightRepository;
        public TimeSlotService(ITimeSlotRepository repository, IFlightRepository flightRepository)
        {
            _repository = repository;
            _flightRepository = flightRepository;
        }

        public async Task<bool> DeleteTimeSlot(int timeSlotId)
        {
            return await _repository.DeleteTimeSlot(timeSlotId);
        }

        public async Task<IEnumerable<TimeSlot>> GetRestTimeSlotOfFlight(string startPointId, string endPointId, DateTime flightDate)
        {
            var timeSlotList = await _repository.GetTimeSlotByFlightDirection(startPointId, endPointId);
            var flightList = await _flightRepository.GetFlightBySearchData(startPointId, endPointId, flightDate);
            List<TimeSlot> timeSlots = new List<TimeSlot>();
            if(timeSlotList != null && flightList != null)
            {
                foreach (var timeSlot in timeSlotList)
                {
                    bool isContain = false;
                    foreach (var flight in flightList)
                    {
                        if (flight.StartTime.TotalSeconds == timeSlot.StartTime.TotalSeconds)
                        {
                            isContain = true;
                            break;
                        }
                    }
                    if (!isContain)
                    {
                        timeSlots.Add(timeSlot);
                    }
                }
            }else if(timeSlotList != null && flightList == null)
            {
                return timeSlotList;
            }

            return timeSlots;
        }

        public async Task<IEnumerable<TimeSlot>> GetTimeSlotByFlightDirection(string startPointId, string endPointId)
        {
            return await _repository.GetTimeSlotByFlightDirection(startPointId, endPointId);
        }

        public async Task<bool> InsertTimeSlot(string startTime, string endTime, string startPointId, string endPointId)
        {
            return await _repository.InsertTimeSlot(startTime, endTime, startPointId, endPointId);
        }

        public async Task<bool> UpdateTimeSlot(int timeSlotId, string startTime, string endTime, string startPointId, string endPointId)
        {
            return await _repository.UpdateTimeSlot(timeSlotId, startTime, endTime, startPointId, endPointId);
        }
    }
}
