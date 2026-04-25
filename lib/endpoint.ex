defmodule DemoServer.Endpoint do
  use GRPC.Endpoint

  run(DemoServer.ServiceImpl)
end
