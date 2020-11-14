using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ArsApi.Contexts;
using ArsApi.Models;
using ArsApi.Repositories;
using ArsApi.Repositories.Implements;
using ArsApi.Services;
using ArsApi.Services.Implements;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;

namespace ArsApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy(name: "ArsApiPolicy", builder =>
                    builder.WithOrigins("http://localhost:3000")
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .AllowCredentials().Build());
            });
            services.AddControllers();
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer= true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer=Configuration["Jwt:Issuer"],
                        ValidAudience= Configuration["Jwt:Issuer"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
                    };
                });
            services.TryAddScoped<ICustomerRepository, CustomerRepository>();
            services.TryAddScoped<ICustomerService, CustomerService>();
            services.TryAddScoped<IFlightRepository, FlightRepository>();
            services.TryAddScoped<IFlightService, FlightService>();
            services.TryAddScoped<ITicketClassDetailRepository, TicketClassDetailRepository>();
            services.TryAddScoped<IBookingRepository, BookingRepository>();
            services.TryAddScoped<IBookingService, BookingService>();
            services.TryAddScoped<ITicketRepository, TicketRepository>();
            services.TryAddScoped<ITicketService, TicketService>();
            services.TryAddScoped<IMailService, MailService>();
            services.AddDbContext<MSSqlContext>(options =>
                options.UseSqlServer(Configuration.GetConnectionString("ArsDatabase"))
            );
            services.AddOptions();
            services.Configure<MailSetting>(Configuration.GetSection("MailSettings"));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseStaticFiles();

            app.UseRouting();

            app.UseCors("ArsApiPolicy");

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
