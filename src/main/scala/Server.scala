import demo.v1.v1.ZioV1
import demo.v1.v1.{EchoRequest, EchoResponse, HealthResponse}
import com.google.protobuf.empty.Empty
import io.grpc.StatusException
import scalapb.zio_grpc.{ServerLayer, ServiceList}
import zio.*

object DemoServiceImpl extends ZioV1.DemoService:
  def echo(request: EchoRequest): IO[StatusException, EchoResponse] =
    ZIO.succeed(EchoResponse(message = request.message))

  def health(request: Empty): IO[StatusException, HealthResponse] =
    ZIO.succeed(HealthResponse(status = "ok"))

object Server extends ZIOAppDefault:
  def run =
    ServerLayer
      .fromServiceList(
        io.grpc.ServerBuilder.forPort(50051),
        ServiceList.add(DemoServiceImpl)
      )
      .launch
      .tapError(err => ZIO.logError(s"Server error: $err"))
      *> ZIO.never
