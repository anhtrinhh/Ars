using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ArsApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class FlightDirectionController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            var fileJsonPath = "wwwroot/data/flight-direction.json";
            string jsonContent = null;
            try
            {
                jsonContent = System.IO.File.ReadAllText(fileJsonPath);
            } catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            return jsonContent;
        }
    }
}
