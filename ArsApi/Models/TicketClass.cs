using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class TicketClass
    {
        public TicketClass()
        {
            TicketClassDetail = new HashSet<TicketClassDetail>();
        }

        public string TicketClassId { get; set; }
        public string TicketClassName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual ICollection<TicketClassDetail> TicketClassDetail { get; set; }
    }
}
