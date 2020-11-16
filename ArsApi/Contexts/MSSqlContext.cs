using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using ArsApi.Models;

namespace ArsApi.Contexts
{
    public partial class MSSqlContext : DbContext
    {
        public MSSqlContext(DbContextOptions<MSSqlContext> options)
            : base(options)
        {
        }

        public virtual DbSet<AdminAccount> AdminAccount { get; set; }
        public virtual DbSet<Booking> Booking { get; set; }
        public virtual DbSet<CustomerAccount> CustomerAccount { get; set; }
        public virtual DbSet<Flight> Flight { get; set; }
        public virtual DbSet<Ticket> Ticket { get; set; }
        public virtual DbSet<TicketClass> TicketClass { get; set; }
        public virtual DbSet<TicketClassDetail> TicketClassDetail { get; set; }
        public virtual DbSet<TimeSlot> TimeSlot { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AdminAccount>(entity =>
            {
                entity.HasKey(e => e.AdminId)
                    .HasName("PK__AdminAcc__719FE488C3E0DDFA");

                entity.HasIndex(e => e.AdminEmail)
                    .HasName("UQ__AdminAcc__F2AA7AD920ED1C8F")
                    .IsUnique();

                entity.HasIndex(e => e.AdminPhoneNumber)
                    .HasName("UQ__AdminAcc__75CD9DADD8D4611A")
                    .IsUnique();

                entity.Property(e => e.AdminId)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.AdminAvatar)
                    .IsRequired()
                    .HasMaxLength(100)
                    .HasDefaultValueSql("('admin_avatar.png')");

                entity.Property(e => e.AdminBirthday).HasColumnType("date");

                entity.Property(e => e.AdminEmail)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.AdminFirstName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.AdminLastName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.AdminPassword)
                    .IsRequired()
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.AdminPhoneNumber)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.CreatorId)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.Salt)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Creator)
                    .WithMany(p => p.InverseCreator)
                    .HasForeignKey(d => d.CreatorId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_AdminAccount_CreatorId");
            });

            modelBuilder.Entity<Booking>(entity =>
            {
                entity.Property(e => e.BookingId)
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.CustomerNo)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.FlightId)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.CustomerNoNavigation)
                    .WithMany(p => p.Booking)
                    .HasForeignKey(d => d.CustomerNo)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Booking_CustomerNo");

                entity.HasOne(d => d.Flight)
                    .WithMany(p => p.Booking)
                    .HasForeignKey(d => d.FlightId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Booking_FlightId");
            });

            modelBuilder.Entity<CustomerAccount>(entity =>
            {
                entity.HasKey(e => e.CustomerNo)
                    .HasName("PK__Customer__A4AFBF635B082829");

                entity.HasIndex(e => e.CustomerEmail)
                    .HasName("UQ__Customer__3A0CE74C7BB4943A")
                    .IsUnique();

                entity.HasIndex(e => e.CustomerIdentification)
                    .HasName("UQ__Customer__5B12FE7223F5D88E")
                    .IsUnique();

                entity.HasIndex(e => e.CustomerPhoneNumber)
                    .HasName("UQ__Customer__AEB4E9D920D79833")
                    .IsUnique();

                entity.Property(e => e.CustomerNo)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.CustomerAddress)
                    .IsRequired()
                    .HasMaxLength(200);

                entity.Property(e => e.CustomerAvatar)
                    .IsRequired()
                    .HasMaxLength(200)
                    .HasDefaultValueSql("('guest_avatar.png')");

                entity.Property(e => e.CustomerBirthday).HasColumnType("date");

                entity.Property(e => e.CustomerEmail)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CustomerFirstName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.CustomerIdentification)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.CustomerLastName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.CustomerPassword).HasMaxLength(200);

                entity.Property(e => e.CustomerPhoneNumber)
                    .IsRequired()
                    .HasMaxLength(15)
                    .IsUnicode(false);

                entity.Property(e => e.EmailToken).HasMaxLength(10);

                entity.Property(e => e.Salt)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");
            });

            modelBuilder.Entity<Flight>(entity =>
            {
                entity.HasIndex(e => new { e.StartTime, e.EndTime, e.FlightDate, e.StartPointId, e.EndPointId, e.FlightStatus })
                    .HasName("ix_flight");

                entity.Property(e => e.FlightId)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.EndPointId)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.FlightDate).HasColumnType("date");

                entity.Property(e => e.FlightNote).HasMaxLength(200);

                entity.Property(e => e.StartPointId)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");
            });

            modelBuilder.Entity<Ticket>(entity =>
            {
                entity.Property(e => e.BookingId)
                    .IsRequired()
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.GuestBirthday).HasColumnType("datetime");

                entity.Property(e => e.GuestFirstName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.GuestLastName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.TicketClass)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.TicketStatus)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Booking)
                    .WithMany(p => p.Ticket)
                    .HasForeignKey(d => d.BookingId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Ticket_BookingId");

                entity.HasOne(d => d.TicketClassDetail)
                    .WithMany(p => p.Ticket)
                    .HasForeignKey(d => d.TicketClassDetailId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Ticket_TicketClassDetailId");
            });

            modelBuilder.Entity<TicketClass>(entity =>
            {
                entity.HasIndex(e => e.TicketClassName)
                    .HasName("UQ__TicketCl__246E05AC62077000")
                    .IsUnique();

                entity.Property(e => e.TicketClassId)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.TicketClassName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");
            });

            modelBuilder.Entity<TicketClassDetail>(entity =>
            {
                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.FlightId)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.TicketClassId)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.HasOne(d => d.Flight)
                    .WithMany(p => p.TicketClassDetail)
                    .HasForeignKey(d => d.FlightId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_TicketClassDetail_FlightId");

                entity.HasOne(d => d.TicketClass)
                    .WithMany(p => p.TicketClassDetail)
                    .HasForeignKey(d => d.TicketClassId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_TicketClassDetail_TicketClassId");
            });

            modelBuilder.Entity<TimeSlot>(entity =>
            {
                entity.HasIndex(e => new { e.StartTime, e.EndTime, e.StartPointId, e.EndPointId })
                    .HasName("ix_timeSlot");

                entity.Property(e => e.CreatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.EndPointId)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.StartPointId)
                    .IsRequired()
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.UpdatedAt)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
