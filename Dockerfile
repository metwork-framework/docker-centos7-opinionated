FROM centos:centos7
MAINTAINER Fabien MARTY <fabien.marty@gmail.com>

ENV DCO_CRONIE_START=1 \
    DCO_SSHD_START=0 \
    DCO_SSHD_FORCE_RSA_HOST_KEY= \
    DCO_SSHD_FORCE_RSA_HOST_PUB_KEY= \
    DCO_SSHD_FORCE_ECDSA_HOST_KEY= \
    DCO_SSHD_FORCE_ECDSA_HOST_PUB_KEY= \
    DCO_SSHD_FORCE_ED25519_HOST_KEY= \
    DCO_SSHD_FORCE_ED25519_HOST_PUB_KEY= \
    DCO_SSHD_ADD_ROOT_AUTHORIZED_KEY= \
    DCO_FORCE_ROOT_PASSWORD= \
    S6_KEEP_ENV=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=1

COPY root /

# Update the image, install cronie, openssh-server and wget
# The, S6 overlay and clean
RUN yum -y update && \
    yum -y install wget cronie openssh-server && \
    yum clean all && \
    /build/s6_overlay.sh && \
    rm -Rf /buid

ENTRYPOINT ["/init"]
