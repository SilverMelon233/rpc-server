import GRPC
import NIO
import SwiftProtobuf
import DemoStub

final class DemoServiceProvider: Demo_V1_DemoServiceProvider {
    var interceptors: Demo_V1_DemoServiceServerInterceptorFactoryProtocol? { nil }

    func echo(
        request: Demo_V1_EchoRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Demo_V1_EchoResponse> {
        var response = Demo_V1_EchoResponse()
        response.message = request.message
        return context.eventLoop.makeSucceededFuture(response)
    }

    func health(
        request: Google_Protobuf_Empty,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Demo_V1_HealthResponse> {
        var response = Demo_V1_HealthResponse()
        response.status = "ok"
        return context.eventLoop.makeSucceededFuture(response)
    }
}

let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "50051") ?? 50051
let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer { try? group.syncShutdownGracefully() }

let server = try Server.insecure(group: group)
    .withServiceProviders([DemoServiceProvider()])
    .bind(host: "0.0.0.0", port: port)
    .wait()

print("gRPC server listening on port \(server.channel.localAddress!.port!)")
try server.onClose.wait()
