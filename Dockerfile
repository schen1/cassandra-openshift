FROM registry.redhat.io/ubi7/ubi
LABEL maintainer "Sylvain Chen <sychen@redhat.com>"

ARG CASSANDRA_VERSION

ENV CASSANDRA_CLIENT_ENCRYPTION="false" \
    CASSANDRA_CLUSTER_NAME="My Cluster" \
    CASSANDRA_CQL_PORT_NUMBER="9042" \
    CASSANDRA_DATACENTER="dc1" \
    CASSANDRA_ENABLE_REMOTE_CONNECTIONS="true" \
    CASSANDRA_ENABLE_RPC="true" \
    CASSANDRA_ENDPOINT_SNITCH="SimpleSnitch" \
    CASSANDRA_HOST="" \
    CASSANDRA_INTERNODE_ENCRYPTION="none" \
    CASSANDRA_JMX_PORT_NUMBER="7199" \
    CASSANDRA_KEYSTORE_PASSWORD="cassandra" \
    CASSANDRA_NUM_TOKENS="256" \
    CASSANDRA_PASSWORD="cassandra" \
    CASSANDRA_PASSWORD_SEEDER="no" \
    CASSANDRA_RACK="rack1" \
    CASSANDRA_SEEDS="" \
    CASSANDRA_STARTUP_CQL="" \
    CASSANDRA_TRANSPORT_PORT_NUMBER="7000" \
    CASSANDRA_TRUSTSTORE_PASSWORD="cassandra" \
    CASSANDRA_USER="cassandra" \
    PATH="${PATH}:/usr/local/apache-cassandra-${CASSANDRA_VERSION}/bin" \
    CASSANDRA_HOME=/usr/local/apache-cassandra-${CASSANDRA_VERSION} \
    CASSANDRA_CONF=/etc/cassandra \
    CASSANDRA_DATA=/cassandra_data \
    CASSANDRA_LOGS=/var/log/cassandra

# Install required system packages and dependencies
USER root
RUN yum install -y yum-utils unzip tar rsync java-1.8.0-openjdk-devel python bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib wget 
ADD files /

RUN /build.sh \
    && rm /build.sh

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

VOLUME ["/$CASSANDRA_DATA"]

USER 1001

CMD ["/usr/local/bin/dumb-init", "/bin/bash", "/run.sh"]
