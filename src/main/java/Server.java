import demo.v1.DemoServiceGrpc;
import demo.v1.V1;
import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.grpc.stub.StreamObserver;

public class Server {
    public static void main(String[] args) throws Exception {
        Server server = ServerBuilder.forPort(50051)
                .addService(new DemoServiceImpl())
                .build()
                .start();
        System.out.println("Server started on port 50051");
        server.awaitTermination();
    }

    static class DemoServiceImpl extends DemoServiceGrpc.DemoServiceImplBase {
        @Override
        public void echo(V1.EchoRequest request, StreamObserver<V1.EchoResponse> responseObserver) {
            V1.EchoResponse response = V1.EchoResponse.newBuilder()
                    .setMessage(request.getMessage())
                    .build();
            responseObserver.onNext(response);
            responseObserver.onCompleted();
        }

        @Override
        public void health(com.google.protobuf.Empty request, StreamObserver<V1.HealthResponse> responseObserver) {
            V1.HealthResponse response = V1.HealthResponse.newBuilder()
                    .setStatus("ok")
                    .build();
            responseObserver.onNext(response);
            responseObserver.onCompleted();
        }
    }
}
