using DemoServer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

Host.CreateDefaultBuilder(args)
    .ConfigureWebHostDefaults(web =>
    {
        web.ConfigureKestrel(o => o.ListenAnyIP(50051, l => l.Protocols = HttpProtocols.Http2));
        web.ConfigureServices(s => s.AddGrpc());
        web.Configure(app =>
        {
            app.UseRouting();
            app.UseEndpoints(e => e.MapGrpcService<DemoServiceImpl>());
        });
    })
    .Build()
    .Run();
