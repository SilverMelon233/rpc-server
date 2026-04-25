import * as grpc from '@grpc/grpc-js';
import { type IDemoService, demoServiceDefinition } from './gen/demo/v1.grpc-server.js';
import { EchoResponse, HealthResponse } from './gen/demo/v1.js';

const impl: IDemoService = {
  echo(call, callback) {
    callback(null, EchoResponse.create({ message: call.request.message }));
  },
  health(_call, callback) {
    callback(null, HealthResponse.create({ status: 'ok' }));
  },
};

const server = new grpc.Server();
server.addService(demoServiceDefinition, impl);
server.bindAsync('0.0.0.0:50051', grpc.ServerCredentials.createInsecure(), (err, port) => {
  if (err) { console.error('Failed to bind:', err); process.exit(1); }
  console.log(`gRPC server listening on :${port}`);
});
