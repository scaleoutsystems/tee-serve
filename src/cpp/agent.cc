#include <grpcpp/server_builder.h>
#include <grpcpp/server_context.h>

#include "api.grpc.pb.h"

using api::PredictionRequest;
using api::PredictionResponse;
using api::Predictor;
using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;

class PredictorImpl final : public Predictor::Service {
  Status Predict(ServerContext* context, const PredictionRequest* req,
                 PredictionResponse* res) override {
    res->set_prediction(req->input());
    return Status::OK;
  }
};

void RunAgent() {
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
  RunAgent();
  return 0;
}