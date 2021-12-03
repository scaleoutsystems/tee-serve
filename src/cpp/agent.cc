#include <grpcpp/server_builder.h>
#include <grpcpp/server_context.h>

#include "api.grpc.pb.h"
#include "tensorflow/lite/interpreter.h"
#include "tensorflow/lite/kernels/register.h"
#include "tensorflow/lite/model.h"
#include "tensorflow/lite/optional_debug_tools.h"

using api::PredictionRequest;
using api::PredictionResponse;
using api::Predictor;
using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;

class PredictorImpl final : public Predictor::Service {
 private:
  std::unique_ptr<tflite::Interpreter> interpreter;

 public:
  PredictorImpl() {
    // Load model
    std::unique_ptr<tflite::FlatBufferModel> model =
        tflite::FlatBufferModel::BuildFromFile("resources/model.tflite");
    if (model == nullptr) {
      std::cerr << "Model load: Error" << std::endl;
      exit(1);
    } else {
      std::cerr << "Model load: OK" << std::endl;
    }

    // Build TF interpreter
    tflite::ops::builtin::BuiltinOpResolver resolver;
    if (tflite::InterpreterBuilder(*model, resolver)(&interpreter) ==
        kTfLiteOk) {
      std::cerr << "Interpreter build: OK" << std::endl;
    } else {
      std::cerr << "Interpreter build: Error" << std::endl;
      exit(1);
    }

    // Allocate tensors
    if (interpreter->AllocateTensors() == kTfLiteOk) {
      std::cerr << "Allocate tensors: OK" << std::endl;
      tflite::PrintInterpreterState(interpreter.get());
    } else {
      std::cerr << "Allocate tensors: Error" << std::endl;
      exit(1);
    }
  }

  Status Predict(ServerContext* context, const PredictionRequest* req,
                 PredictionResponse* res) override {
    // Run inference
    interpreter->typed_input_tensor<float>(0)[0] = req->input();
    interpreter->Invoke();

    // Set gRPC response
    res->set_prediction(interpreter->typed_output_tensor<float>(0)[0]);
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