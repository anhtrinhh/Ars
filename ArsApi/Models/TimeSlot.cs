using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class TimeSlot
    {
        public int TimeSlotId { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public string StartPointId { get; set; }
        public string EndPointId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
