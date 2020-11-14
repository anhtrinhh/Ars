using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using ArsApi.Models;
using ArsApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ArsApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class BookingController : ControllerBase
    {
        private readonly IBookingService _service;
        public BookingController(IBookingService service)
        {
            _service = service;
        }

        [Authorize]
        [HttpGet]
        public async Task<IEnumerable<Booking>> GetBookingByCustomerNo()
        {
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            var customerNo = claims[0].Value;
            return await _service.GetBookingByCustomerNo(customerNo);
        }

        [Authorize]
        [HttpPost]
        public async Task<string> InsertBooking(Booking booking)
        {
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            IList<Claim> claims = identity.Claims.ToList();
            var customerNo = claims[0].Value;
            booking.CustomerNo = customerNo;
            return await _service.InsertBooking(booking);
        }
    }
}
