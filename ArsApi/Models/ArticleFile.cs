using System;
using System.Collections.Generic;

namespace ArsApi.Models
{
    public partial class ArticleFile
    {
        public int ArticleFileId { get; set; }
        public string ArticleFileName { get; set; }
        public int ArticleId { get; set; }
        public bool ArticleFileType { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public virtual Article Article { get; set; }
    }
}
