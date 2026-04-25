defmodule DemoServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :demo_server,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [mod: {DemoServer.Application, []}, extra_applications: [:logger]]
  end

  defp deps do
    [
      {:grpc, "~> 0.11"},
      {:protobuf, "~> 0.16"}
    ]
  end
end
