using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class CustomerAccount
    {
        public CustomerAccount()
        {
            Booking = new HashSet<Booking>();
        }

        public string CustomerNo { get; set; }
        public string CustomerFirstName { get; set; }
        public string CustomerLastName { get; set; }
        public bool CustomerGender { get; set; }
        public DateTime CustomerBirthday { get; set; }
        public string CustomerPhoneNumber { get; set; }
        public string CustomerEmail { get; set; }
        public string CustomerPassword { get; set; }
        public string CustomerIdentification { get; set; }
        public string CustomerAvatar { get; set; }
        public string CustomerAddress { get; set; }
        public string Salt { get; set; }
        public string EmailToken { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual ICollection<Booking> Booking { get; set; }
    }
}
