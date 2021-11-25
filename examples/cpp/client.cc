#include <grpc/grpc.h>
#include <grpcpp/channel.h>
#include <grpcpp/client_context.h>
#include <grpcpp/create_channel.h>
#include <grpcpp/security/credentials.h>

class Client {
 public:
  Client(std::shared_ptr<Channel> channel, const std::string& db)
      : stub_(RouteGuide::NewStub(channel)) {
    routeguide::ParseDb(db, &feature_list_);
  }
};

int main(int argc, char** argv) {
  grpc::CreateChannel("localhost:50051", grpc::InsecureChannelCredentials());
  return 0;
}