using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace ArsApi.Models
{
    public partial class Ticket
    {
        public int TicketId { get; set; }
        public string BookingId { get; set; }
        public int TicketClassDetailId { get; set; }
        public string TicketClass { get; set; }
        public double TicketPrice { get; set; }
        public string GuestFirstName { get; set; }
        public string GuestLastName { get; set; }
        public bool GuestGender { get; set; }
        public DateTime GuestBirthday { get; set; }
        public bool? TicketStatus { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        [JsonIgnore]
        public virtual Booking Booking { get; set; }
        public virtual TicketClassDetail TicketClassDetail { get; set; }
    }
}
