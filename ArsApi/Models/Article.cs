using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class Article
    {
        public Article()
        {
            ArticleFile = new HashSet<ArticleFile>();
        }

        public int ArticleId { get; set; }
        public string ArticleTitle { get; set; }
        public string ArticleContent { get; set; }
        public int ArticleTypeId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual ArticleType ArticleType { get; set; }
        public virtual ICollection<ArticleFile> ArticleFile { get; set; }
    }
}
