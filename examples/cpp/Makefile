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
PROTOS_PATH = ../../build
BUILD_PATH = build

vpath %.proto $(PROTOS_PATH)

all: dir $(BUILD_PATH)/client

dir:
	mkdir -p $(BUILD_PATH)

$(BUILD_PATH)/client: $(PROTOS_PATH)/api.pb.o $(PROTOS_PATH)/api.grpc.pb.o client.o
	$(CXX) $^ $(LDFLAGS) -o $@

clean:
	rm -f *.o $(PROTOS_PATH)/client