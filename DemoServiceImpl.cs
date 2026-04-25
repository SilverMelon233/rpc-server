using Demo.V1;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;

namespace DemoServer;

public class DemoServiceImpl : DemoService.DemoServiceBase
{
    public override Task<EchoResponse> Echo(EchoRequest request, ServerCallContext context)
    {
        return Task.FromResult(new EchoResponse { Message = request.Message });
    }

    public override Task<HealthResponse> Health(Empty request, ServerCallContext context)
    {
        return Task.FromResult(new HealthResponse { Status = "ok" });
    }
}
