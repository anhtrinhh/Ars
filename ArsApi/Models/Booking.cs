using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class Booking
    {
        public Booking()
        {
            Ticket = new HashSet<Ticket>();
        }

        public string BookingId { get; set; }
        public int NumberAdults { get; set; }
        public int NumberChildren { get; set; }
        public int NumberInfants { get; set; }
        public int TotalCustomer { get; set; }
        public double TotalTex { get; set; }
        public double TotalTicketPrice { get; set; }
        public double TotalPrice { get; set; }
        public string CustomerNo { get; set; }
        public string FlightId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual CustomerAccount CustomerNoNavigation { get; set; }
        public virtual Flight Flight { get; set; }
        public virtual ICollection<Ticket> Ticket { get; set; }
    }
}
