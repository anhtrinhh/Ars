using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class AdminAccount
    {
        public AdminAccount()
        {
            InverseCreator = new HashSet<AdminAccount>();
        }

        public string AdminId { get; set; }
        public string AdminFirstName { get; set; }
        public string AdminLastName { get; set; }
        public string AdminPassword { get; set; }
        public string AdminAvatar { get; set; }
        public DateTime AdminBirthday { get; set; }
        public string AdminEmail { get; set; }
        public string AdminPhoneNumber { get; set; }
        public bool AdminGender { get; set; }
        public int AdminRights { get; set; }
        public string Salt { get; set; }
        public string CreatorId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual AdminAccount Creator { get; set; }
        public virtual ICollection<AdminAccount> InverseCreator { get; set; }
    }
}
