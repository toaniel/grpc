sudo apt-get install build-essential autoconf libtool pkg-config
sudo apt-get install cmake libc-ares-dev libc-ares2 libssh-dev python-protobuf protobuf-compiler-grpc libgrpc-dev python-etcd3gw libprotobuf-c-dev/bionic
sudo apt install libc-ares-dev libc-ares2 python-pycares 
sudo apt install libprotoc-dev libprotoc10 libprotocol-osc-perl

bazel build :all
bazel test --config=dbg //test/...
mkdir -p cmake/build
cd third-party/abseil-cpp/Cmake
cmake ..
make
sudo make install
cd ../..
cd cmake/build
cmake ../..
make
cmake ../.. -DgRPC_INSTALL=ON                \
              -DCMAKE_BUILD_TYPE=Release       \
              -DgRPC_ABSL_PROVIDER=package     \
              -DgRPC_CARES_PROVIDER=package    \
              -DgRPC_PROTOBUF_PROVIDER=package \
              -DgRPC_SSL_PROVIDER=package      \
              -DgRPC_ZLIB_PROVIDER=package
#fh:  workaround path issues with google's grpc
find ~/elk/grpc/third_party/protobuf/ \( -type d -name .h -prune \) -o -type f -print0 | xargs -0 sed -i 's/<google\/protobuf/<\/home\/fausto\/elk\/grpc\/third_party\/protobuf\/src\/google\/protobuf/g'
make
make install
#By default gRPC uses [protocol buffers](https://github.com/google/protobuf),
