using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class ArticleType
    {
        public ArticleType()
        {
            Article = new HashSet<Article>();
        }

        public int ArticleTypeId { get; set; }
        public string ArticleTypeName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual ICollection<Article> Article { get; set; }
    }
}
