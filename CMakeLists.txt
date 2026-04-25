cmake_minimum_required(VERSION 3.16)
project(demo_server VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 17)

find_package(Protobuf REQUIRED)
find_package(gRPC REQUIRED)


include_directories(gen)
add_executable(demo-server demo_server.cc gen/demo/v1.pb.cc gen/demo/v1.grpc.pb.cc)
target_link_libraries(demo-server PRIVATE gRPC::grpc++ protobuf::libprotobuf)
