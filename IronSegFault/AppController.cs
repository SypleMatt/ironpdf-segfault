using IronPdf.Engines.Chrome;
using Microsoft.AspNetCore.Mvc;

namespace IronSegFault;

public class AppController : Controller
{
    [HttpGet("/")]
    public IActionResult Index()
    {
        return View("Index");
    }
    
    [HttpGet("/CauseNullRefException")]
    public IActionResult CauseNullRefException()
    {
        try
        {
            string value = null;
            return Ok(value.ToString());
        }
        catch (NullReferenceException)
        {
            return Ok("Null reference exception was thrown and caught");
        }
    }

    [HttpGet("/InitialiseIronPdf")]
    public IActionResult InitialiseIronPdf()
    {
        IronPdf.Installation.SendAnonymousAnalyticsAndCrashData = false;
        IronPdf.Installation.ChromeGpuMode = ChromeGpuModes.Disabled;
        IronPdf.Installation.AutomaticallyDownloadNativeBinaries = true;
        IronPdf.Installation.Initialize();
        
        return Ok("Initialised successfully");
    }
}