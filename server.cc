#include <iostream>
#include <memory>
#include <string>

#include <grpcpp/grpcpp.h>
#include "demo/v1.grpc.pb.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using demo::v1::DemoService;
using demo::v1::EchoRequest;
using demo::v1::EchoResponse;
using demo::v1::HealthResponse;
using google::protobuf::Empty;

class DemoServiceImpl final : public DemoService::Service {
public:
    Status Echo(ServerContext* /*context*/,
                const EchoRequest* request,
                EchoResponse* response) override {
        response->set_message(request->message());
        return Status::OK;
    }

    Status Health(ServerContext* /*context*/,
                  const Empty* /*request*/,
                  HealthResponse* response) override {
        response->set_status("ok");
        return Status::OK;
    }
};

int main() {
    const char* port_env = std::getenv("PORT");
    std::string port = port_env ? port_env : "50051";
    std::string server_address = "0.0.0.0:" + port;

    DemoServiceImpl service;
    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "gRPC server listening on " << server_address << std::endl;
    server->Wait();
    return 0;
}
