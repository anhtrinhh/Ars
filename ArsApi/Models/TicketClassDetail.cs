using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace ArsApi.Models
{
    public partial class TicketClassDetail
    {
        public TicketClassDetail()
        {
            Ticket = new HashSet<Ticket>();
        }

        public int TicketClassDetailId { get; set; }
        public string TicketClassId { get; set; }
        public string FlightId { get; set; }
        public double AdultTicketPrice { get; set; }
        public double ChildTicketPrice { get; set; }
        public double InfantTicketPrice { get; set; }
        public double AdultTex { get; set; }
        public double ChildTex { get; set; }
        public double InfantTex { get; set; }
        public int NumberTicket { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        [JsonIgnore]
        public virtual Flight Flight { get; set; }
        public virtual TicketClass TicketClass { get; set; }
        public virtual ICollection<Ticket> Ticket { get; set; }
    }
}
