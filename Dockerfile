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

# TODO: Run the examples
# TODO: Clean up