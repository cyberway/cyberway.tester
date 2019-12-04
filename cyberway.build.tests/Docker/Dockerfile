ARG builder=master
FROM cyberway/cyberway.contracts:master as contracts
FROM cyberway/builder:$builder as builder
ARG branch=master
ARG symbol=CYBER
ARG compiletype=RelWithDebInfo
ARG ref=heads/$branch

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install openssl ca-certificates python3 python3-numpy python3-bson python3-pymongo python3-requests python3-testfixtures socat mc mcedit libusb-1.0-0-dev libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*

ADD https://api.github.com/repos/cyberway/cyberway/git/refs/$ref /etc/version.json

RUN git clone -b $branch https://github.com/cyberway/cyberway.git --recursive

RUN mkdir /opt/cyberway.build

RUN cd /opt/cyberway.build \
    && echo "$branch:$(git rev-parse HEAD)" > /etc/cyberway-version \
    && cmake /cyberway \
        -GNinja \
        -DCMAKE_BUILD_TYPE=$compiletype \
        -DWASM_ROOT=/opt/wasm \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_INSTALL_PREFIX=/opt/cyberway \
        -DBUILD_MONGO_DB_PLUGIN=false \
        -DCORE_SYMBOL_NAME=$symbol \
    && cmake --build ./

COPY --from=contracts /opt/cyberway.contracts/cyber.bios /opt/cyberway.build/contracts/cyber.bios
COPY --from=contracts /opt/cyberway.contracts/cyber.msig /opt/cyberway.build/contracts/cyber.msig
COPY --from=contracts /opt/cyberway.contracts/cyber.token /opt/cyberway.build/contracts/cyber.token
COPY --from=contracts /opt/cyberway.contracts/cyber.stake /opt/cyberway.build/contracts/cyber.stake





