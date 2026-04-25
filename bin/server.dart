import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart';
import 'package:demo_stub/demo/v1.pbgrpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';

class DemoServiceImpl extends DemoServiceBase {
  @override
  Future<EchoResponse> echo(ServiceCall call, EchoRequest request) async {
    return EchoResponse()..message = request.message;
  }

  @override
  Future<HealthResponse> health(ServiceCall call, Empty request) async {
    return HealthResponse()..status = 'ok';
  }
}

Future<void> main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '50051') ?? 50051;
  final server = Server.create(services: [DemoServiceImpl()]);
  await server.serve(port: port);
  print('gRPC server listening on port ${server.port}');
}
