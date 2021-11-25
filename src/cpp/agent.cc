
#include <grpcpp/server_context.h>
#include <grpcpp/server_builder.h>

#include "api.grpc.pb.h"

using grpc::ServerContext;
using grpc::Status;
using grpc::ServerBuilder;
using grpc::Server;
using api::Predictor;
using api::PredictionRequest;
using api::PredictionResponse;

class PredictorImpl final : public Predictor::Service {

    Status Predict(ServerContext* context, const PredictionRequest* req, PredictionResponse* res) override {
        res->set_prediction(req->input());
        return Status::OK;
    }

};

void RunServer() {
  // Init predictor implementation
  PredictorImpl service;

  // Start server
  std::string server_address("0.0.0.0:50051");
  ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;
  server->Wait();
}

int main(int argc, char** argv) {
  RunServer();
  return 0;
}