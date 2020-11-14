using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace ArsApi.Models
{
    public partial class Flight
    {
        public Flight()
        {
            Booking = new HashSet<Booking>();
            TicketClassDetail = new HashSet<TicketClassDetail>();
        }

        public string FlightId { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public bool FlightStatus { get; set; }
        public DateTime FlightDate { get; set; }
        public string FlightNote { get; set; }
        public string StartPointId { get; set; }
        public string EndPointId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        [JsonIgnore]
        public virtual ICollection<Booking> Booking { get; set; }
        public virtual ICollection<TicketClassDetail> TicketClassDetail { get; set; }
    }
}
