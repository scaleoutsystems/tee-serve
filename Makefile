CXX = g++
CPPFLAGS += `pkg-config --cflags protobuf grpc`
CXXFLAGS += -std=c++17
LDFLAGS += -L/usr/local/lib `pkg-config --libs protobuf grpc++` \
           -pthread \
           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
           -ldl
PROTOC = protoc
GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`
PROTOS_PATH = src/protos
CPP_PATH = src/cpp

vpath %.proto $(PROTOS_PATH)

all: protos agent

protos: $(CPP_PATH)/api.pb.o $(CPP_PATH)/api.grpc.pb.o

agent: $(CPP_PATH)/api.pb.o $(CPP_PATH)/api.grpc.pb.o $(CPP_PATH)/agent.o
	$(CXX) $^ $(LDFLAGS) -o $@

$(CPP_PATH)/%.grpc.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=$(CPP_PATH) --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

$(CPP_PATH)/%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=$(CPP_PATH) $<

clean:
	rm -f $(CPP_PATH)/*.o $(CPP_PATH)/*.pb.cc $(CPP_PATH)/*.pb.h agent
