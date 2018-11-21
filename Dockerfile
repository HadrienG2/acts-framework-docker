# Configure the container's basic properties
#
# FIXME: I'd like to build on acts-tests and reuse my binaries, but ACTSFW is
#        not yet compatible with the latest versions of ROOT and ACTS.
#
FROM hgrasland/spack-tests
LABEL Description="openSUSE Tumbleweed with ACTSFW installed" Version="0.1"
CMD bash

# Switch to a development branch of Spack with the ACTSFW package
#
# FIXME: Switch to upstream once this work is integrated.
#
RUN cd /opt/spack                                                              \
    && git remote add HadrienG2 https://github.com/HadrienG2/spack.git         \
    && git fetch HadrienG2                                                     \
    && git checkout HadrienG2/acts-framework

# Specify a full-featured build of ACTSFW
ENV ACTSFW_SPACK_SPEC="acts-framework@develop +dd4hep +fatras +geant4 +legacy  \
                                              +openmp +tgeo                    \
                       ^ clhep@2.4.0.0"

# Install ACTSFW
RUN spack install ${ACTSFW_SPACK_SPEC}

# Run the framework examples
#
# FIXME: Fix currently failing examples ACTFWBFieldAccessExample,
#        ACTFWBFieldExample, ACTFWDD4hepExtrapolationExample,
#        ACTFWDD4hepGeometryExample, ACTFWDD4hepPropagationExample
#
RUN spack load ${ACTSFW_SPACK_SPEC}                                            \
    && spack load dd4hep                                                       \
    && mkdir ~/tmp                                                             \
    && cd ~/tmp                                                                \
    && ACTFWGenericExtrapolationExample -n 100                                 \
    && ACTFWGenericGeometryExample -n 100                                      \
    && ACTFWGenericPropagationExample -n 100                                   \
    && ACTFWHelloWorldExample -n 100                                           \
    && ACTFWParticleGunExample -n 100                                          \
    && ACTFWRandomNumberExample -n 100                                         \
    && ACTFWRootExtrapolationExample -n 100                                    \
    && ACTFWRootGeometryExample -n 100                                         \
    && ACTFWRootPropagationExample -n 100                                      \
    && ACTFWWhiteBoardExample -n 100                                           \
    && cd ~                                                                    \
    && rm -rf tmp

# Clean up Spack caches and temporary file to shrink the Docker image
RUN spack clean -a

# Discard the framework install: the goal is to provide a known-good framework
# build environment, but the framework is not terribly useful per se.
RUN spack uninstall -y ${ACTSFW_SPACK_SPEC}