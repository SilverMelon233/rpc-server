defmodule DemoServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT", "50051"))
    children = [
      {GRPC.Server.Supervisor, endpoint: DemoServer.Endpoint, port: port, start_server: true}
    ]
    opts = [strategy: :one_for_one, name: DemoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
