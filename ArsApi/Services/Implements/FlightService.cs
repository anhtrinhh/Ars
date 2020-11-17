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
            if(string.IsNullOrEmpty(startPointId) || string.IsNullOrEmpty(endPointId))
            {
                return null;
            }
            var flightList = await _repository.GetFlightBySearchData(startPointId, endPointId, flightDate);
            if(flightList != null)
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
    }
}
