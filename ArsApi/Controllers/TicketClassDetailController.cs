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
    public class TicketClassDetailController : ControllerBase
    {
        private readonly ITicketClassDetailService _service;
        public TicketClassDetailController(ITicketClassDetailService service)
        {
            _service = service;
        }

        [Authorize]
        [HttpPost]
        public async Task<bool> Insert(TicketClassDetail ticketClassDetail)
        {
            return await _service.InsertTicketClassDetail(ticketClassDetail);
        }
    }
}
