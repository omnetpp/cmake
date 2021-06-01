ARG OMNETPP_VERSION=5.6.2
FROM omnetpp/omnetpp:u18.04-$OMNETPP_VERSION
ARG CMAKE_VERSION=3.13.4
ARG OMNETPP_VERSION
RUN wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    bash cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --prefix=/usr/local
ENV EXPECTED_OMNETPP_ROOT=/root/omnetpp
ENV EXPECTED_OMNETPP_VERSION=$OMNETPP_VERSION
ENV TEST_BUILD_DIR=/omnetpp-cmake-test
ENTRYPOINT ["/omnetpp-cmake/tests/run.sh"]
