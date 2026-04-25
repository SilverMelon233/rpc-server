defmodule Demo.V1.DemoService.Service do
  use GRPC.Service, name: "demo.v1.DemoService", protoc_gen_elixir_version: "0.15.0"

  rpc(:Echo, Demo.V1.EchoRequest, Demo.V1.EchoResponse)
  rpc(:Health, Google.Protobuf.Empty, Demo.V1.HealthResponse)
end

defmodule DemoServer.ServiceImpl do
  use GRPC.Server, service: Demo.V1.DemoService.Service

  alias Demo.V1.{EchoRequest, EchoResponse, HealthResponse}

  @spec echo(EchoRequest.t(), GRPC.Server.Stream.t()) :: EchoResponse.t()
  def echo(%EchoRequest{message: msg}, _stream) do
    EchoResponse.new(message: msg)
  end

  @spec health(Google.Protobuf.Empty.t(), GRPC.Server.Stream.t()) :: HealthResponse.t()
  def health(_request, _stream) do
    HealthResponse.new(status: "ok")
  end
end
