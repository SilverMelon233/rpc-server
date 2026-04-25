cmake_minimum_required(VERSION 3.16)
project(demo-server VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 17)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GRPC REQUIRED grpc++)
pkg_check_modules(PROTOBUF REQUIRED protobuf)

include_directories(gen ${GRPC_INCLUDE_DIRS} ${PROTOBUF_INCLUDE_DIRS})
add_executable(demo-server demo_server.cc gen/demo/v1.pb.cc gen/demo/v1.grpc.pb.cc)
target_link_libraries(demo-server PRIVATE ${GRPC_STATIC_LIBRARIES} ${PROTOBUF_STATIC_LIBRARIES} -static-libgcc -static-libstdc++)
target_link_directories(demo-server PRIVATE ${GRPC_LIBRARY_DIRS} ${PROTOBUF_LIBRARY_DIRS})
set_target_properties(demo-server PROPERTIES LINK_FLAGS "-static -static-libgcc -static-libstdc++")
