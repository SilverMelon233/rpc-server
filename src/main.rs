use demo_stub::demo::v1::{
    demo_service_server::{DemoService, DemoServiceServer},
    EchoRequest, EchoResponse, HealthResponse,
};
use tonic::{transport::Server, Request, Response, Status};

#[derive(Default)]
struct DemoServiceImpl;

#[tonic::async_trait]
impl DemoService for DemoServiceImpl {
    async fn echo(
        &self,
        request: Request<EchoRequest>,
    ) -> Result<Response<EchoResponse>, Status> {
        let msg = request.into_inner().message;
        Ok(Response::new(EchoResponse { message: msg }))
    }

    async fn health(
        &self,
        _request: Request<()>,
    ) -> Result<Response<HealthResponse>, Status> {
        Ok(Response::new(HealthResponse {
            status: "ok".to_string(),
        }))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::]:50051".parse()?;
    println!("gRPC server listening on :50051");
    Server::builder()
        .add_service(DemoServiceServer::new(DemoServiceImpl::default()))
        .serve(addr)
        .await?;
    Ok(())
}
