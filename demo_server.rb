require 'grpc'
require 'demo/v1_services_pb'

class DemoServiceImpl < Demo::V1::DemoService::Service
  def echo(req, _call)
    Demo::V1::EchoResponse.new(message: req.message)
  end

  def health(_req, _call)
    Demo::V1::HealthResponse.new(status: 'ok')
  end
end

def main
  port = ENV.fetch('PORT', '50051')
  addr = "0.0.0.0:#{port}"
  server = GRPC::RpcServer.new
  server.add_http2_port(addr, :this_port_is_insecure)
  server.handle(DemoServiceImpl)
  puts "gRPC server listening on #{addr}"
  server.run_till_terminated_or_interrupted([1, 'int', 'SIGTERM'])
end

main
