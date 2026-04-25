import grpc
from concurrent import futures
from demo_stub.demo import v1_pb2, v1_pb2_grpc
from google.protobuf import empty_pb2


class DemoServiceServicer(v1_pb2_grpc.DemoServiceServicer):
    def Echo(self, request, context):
        return v1_pb2.EchoResponse(message=request.message)

    def Health(self, request, context):
        return v1_pb2.HealthResponse(status="ok")


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    v1_pb2_grpc.add_DemoServiceServicer_to_server(DemoServiceServicer(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    print("gRPC server listening on :50051")
    server.wait_for_termination()


if __name__ == "__main__":
    serve()
