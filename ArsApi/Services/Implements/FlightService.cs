using ArsApi.Models;
using ArsApi.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ArsApi.Services.Implements
{
    public class FlightService : IFlightService
    {
        private readonly IFlightRepository _repository;
        private readonly ITicketClassDetailRepository _ticketClassDetailRepository;
        public FlightService(IFlightRepository repository, ITicketClassDetailRepository ticketClassDetailRepository)
        {
            _repository = repository;
            _ticketClassDetailRepository = ticketClassDetailRepository;
        }
        public async Task<IEnumerable<Flight>> SearchFlight(string startPointId, string endPointId, DateTime flightDate)
        {
            if (string.IsNullOrEmpty(startPointId) || string.IsNullOrEmpty(endPointId))
            {
                return null;
            }
            var flightList = await _repository.GetFlightBySearchData(startPointId, endPointId, flightDate);
            if (flightList != null)
            {
                foreach (var flight in flightList)
                {
                    await _ticketClassDetailRepository.GetTicketClassDetailsByFlightId(flight.FlightId);
                }
            }
            return flightList;
        }
        public async Task<bool> InsertFlight(Flight flight)
        {
            return await _repository.InsertFlight(flight);
        }

        public async Task<IEnumerable<Flight>> SearchFlight2(string startPointId, string endPointId, DateTime flightDate)
        {
            if (string.IsNullOrEmpty(startPointId) || string.IsNullOrEmpty(endPointId))
            {
                return null;
            }
            var flightList = await _repository.GetFlightBySearchData2(startPointId, endPointId, flightDate);
            if (flightList != null)
            {
                foreach (var flight in flightList)
                {
                    double now = DateTime.Now.ToUniversalTime()
                    .Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))
                    .TotalDays;
                    double flightD = flight.FlightDate.ToUniversalTime()
                    .Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))
                    .TotalDays;
                    if (!flight.FlightStatus && flightD < now)
                    {
                        await _repository.UpdateFlightStatus(true, flight.FlightId);
                    }
                    await _ticketClassDetailRepository.GetTicketClassDetailsByFlightId(flight.FlightId);
                }
            }
            return flightList;
        }

        public async Task<Flight> GetFlightByFlightId(string flightId)
        {
            var flight = await _repository.GetFlightByFlightId(flightId);
            flight.TicketClassDetail = (ICollection<TicketClassDetail>)await _ticketClassDetailRepository.GetTicketClassDetailsByFlightId(flight.FlightId);
            double now = DateTime.Now.ToUniversalTime()
                .Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))
                .TotalDays;
            double flightDate = flight.FlightDate.ToUniversalTime()
                .Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))
                .TotalDays;
            if (!flight.FlightStatus && flightDate < now)
            {
                await _repository.UpdateFlightStatus(true, flight.FlightId);
            }
            return flight;
        }

        public Task<bool> UpdateFlightStatus(bool flightStatus, string flightId)
        {
            return _repository.UpdateFlightStatus(flightStatus, flightId);
        }
    }
}
