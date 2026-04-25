defmodule DemoServer.Endpoint do
  use GRPC.Endpoint

  intercept(GRPC.Logger.Server)
  run(DemoServer.ServiceImpl)
end
