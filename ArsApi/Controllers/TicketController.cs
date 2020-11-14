using System;
using System.Collections.Generic;
using System.Linq;
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
    public class TicketController : ControllerBase
    {
        private readonly ITicketService _service;
        public TicketController(ITicketService service)
        {
            _service = service;
        }
        [Authorize]
        [HttpPost]
        public async Task<bool> InsertTicket(Ticket ticket)
        {
            return await _service.InsertTicket(ticket);
        }
    }
}
