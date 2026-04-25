defmodule DemoServer.ServiceImpl do
  use GRPC.Server, service: Demo.V1.DemoService.Service

  alias Demo.V1.{EchoRequest, EchoResponse, HealthResponse}

  @spec echo(EchoRequest.t(), GRPC.Server.Stream.t()) :: EchoResponse.t()
  def echo(%EchoRequest{message: msg}, _stream) do
    %EchoResponse{message: msg}
  end

  @spec health(Google.Protobuf.Empty.t(), GRPC.Server.Stream.t()) :: HealthResponse.t()
  def health(_request, _stream) do
    %HealthResponse{status: "ok"}
  end
end
