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
BUILD_PATH = build

vpath %.proto $(PROTOS_PATH)

all: dir protos $(BUILD_PATH)/agent

dir:
	mkdir -p $(BUILD_PATH)

protos: dir $(BUILD_PATH)/api.pb.o $(BUILD_PATH)/api.grpc.pb.o

$(BUILD_PATH)/agent: $(BUILD_PATH)/api.pb.o $(BUILD_PATH)/api.grpc.pb.o $(CPP_PATH)/agent.o
	$(CXX) $^ $(LDFLAGS) -o $@

$(BUILD_PATH)/%.grpc.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=$(BUILD_PATH) --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

$(BUILD_PATH)/%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=$(BUILD_PATH) $<

clean:
	rm -f $(CPP_PATH)/*.o $(BUILD_PATH)/*.o $(BUILD_PATH)/*.pb.cc $(BUILD_PATH)/*.pb.h $(BUILD_PATH)/agent
