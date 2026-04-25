import com.google.protobuf.Empty
import demo.v1.DemoServiceGrpcKt
import demo.v1.V1
import io.grpc.ServerBuilder
import kotlinx.coroutines.runBlocking

class DemoServiceImpl : DemoServiceGrpcKt.DemoServiceCoroutineImplBase() {
    override suspend fun echo(request: V1.EchoRequest): V1.EchoResponse {
        return V1.EchoResponse.newBuilder()
            .setMessage(request.message)
            .build()
    }

    override suspend fun health(request: Empty): V1.HealthResponse {
        return V1.HealthResponse.newBuilder()
            .setStatus("ok")
            .build()
    }
}

fun main() {
    val server = ServerBuilder.forPort(50051)
        .addService(DemoServiceImpl())
        .build()
        .start()
    println("Server started on port 50051")
    server.awaitTermination()
}
