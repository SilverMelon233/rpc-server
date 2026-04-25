using System.Threading.Tasks;
using DemoServer;
using Grpc.Core;

var server = new Grpc.Core.Server
{
    Services = { Demo.V1.DemoService.BindService(new DemoServiceImpl()) },
    Ports = { new ServerPort("0.0.0.0", 50051, ServerCredentials.Insecure) }
};
server.Start();
Console.WriteLine("gRPC server listening on port 50051");
await Task.Delay(Timeout.Infinite);
