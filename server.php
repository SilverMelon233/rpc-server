<?php
require __DIR__ . '/vendor/autoload.php';

use Demo\V1\EchoRequest;
use Demo\V1\EchoResponse;
use Demo\V1\HealthResponse;
use Google\Protobuf\GPBEmpty;

$port = getenv('PORT') ?: '50051';
$server = new Grpc\Server([]);
$server->addHttp2Port("0.0.0.0:{$port}");

$server->requestCall(function ($call) {
    // low-level dispatch loop
});

function handleEcho(EchoRequest $request): EchoResponse
{
    $response = new EchoResponse();
    $response->setMessage($request->getMessage());
    return $response;
}

function handleHealth(GPBEmpty $request): HealthResponse
{
    $response = new HealthResponse();
    $response->setStatus('ok');
    return $response;
}

$handlers = [
    '/demo.v1.DemoService/Echo' => function ($requestBytes) {
        $req = new EchoRequest();
        $req->mergeFromString($requestBytes);
        return handleEcho($req)->serializeToString();
    },
    '/demo.v1.DemoService/Health' => function ($requestBytes) {
        $req = new GPBEmpty();
        $req->mergeFromString($requestBytes);
        return handleHealth($req)->serializeToString();
    },
];

echo "gRPC server listening on port {$port}\n";
$server->start();

while (true) {
    $event = $server->requestCall();
    if (!$event) {
        break;
    }
    $method = $event->method;
    $call   = $event->call;
    $call->startBatch([
        Grpc\OP_SEND_INITIAL_METADATA => [],
    ]);
    $read = $call->startBatch([Grpc\OP_RECV_MESSAGE => true]);
    $requestBytes = $read->message;

    if (isset($handlers[$method])) {
        $responseBytes = ($handlers[$method])($requestBytes);
        $status = Grpc\STATUS_OK;
        $statusMsg = '';
    } else {
        $responseBytes = '';
        $status = Grpc\STATUS_UNIMPLEMENTED;
        $statusMsg = 'Method not found';
    }

    $call->startBatch([
        Grpc\OP_SEND_MESSAGE        => $responseBytes,
        Grpc\OP_SEND_STATUS_FROM_SERVER => [
            'metadata' => [],
            'code'     => $status,
            'details'  => $statusMsg,
        ],
    ]);
}
