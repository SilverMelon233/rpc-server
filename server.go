package main

import (
	"context"
	"log"
	"net"

	demov1 "github.com/SilverMelon233/rpc-stub/gen/demo"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/emptypb"
)

type demoServer struct {
	demov1.UnimplementedDemoServiceServer
}

func (s *demoServer) Echo(_ context.Context, req *demov1.EchoRequest) (*demov1.EchoResponse, error) {
	return &demov1.EchoResponse{Message: req.GetMessage()}, nil
}

func (s *demoServer) Health(_ context.Context, _ *emptypb.Empty) (*demov1.HealthResponse, error) {
	return &demov1.HealthResponse{Status: "ok"}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	demov1.RegisterDemoServiceServer(s, &demoServer{})
	log.Println("gRPC server listening on :50051")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
