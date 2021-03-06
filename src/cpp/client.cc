#include <grpc/grpc.h>
#include <grpcpp/channel.h>
#include <grpcpp/client_context.h>
#include <grpcpp/create_channel.h>
#include <grpcpp/security/credentials.h>

#include <string>

#include "api.grpc.pb.h"

using api::PredictionRequest;
using api::PredictionResponse;
using api::Predictor;
using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;

class Client {
  std::unique_ptr<Predictor::Stub> stub_;

 public:
  Client(std::shared_ptr<Channel> channel)
      : stub_(Predictor::NewStub(channel)) {}

  void PrintPrediction(float input) {
    // Setup context
    ClientContext context;

    // Setup request
    PredictionRequest req;
    req.set_input(input);

    // Call service
    PredictionResponse res;
    Status status = stub_->Predict(&context, req, &res);

    // Print out result if status OK
    if (status.ok()) {
      std::cout << "Prediction is: " << res.prediction() << std::endl;
    } else {
      std::cerr << "Server error" << std::endl;
    }
  }
};

int main(int argc, char** argv) {
  // Init client
  std::shared_ptr<Channel> channel = grpc::CreateChannel(
      "localhost:50051", grpc::InsecureChannelCredentials());
  Client client(channel);

  // Predict
  client.PrintPrediction(std::stof(argv[1]));
  return 0;
}