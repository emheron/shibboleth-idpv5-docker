# Use the latest Ubuntu LTS as the base image
FROM ubuntu:latest

LABEL maintainer="Emmanuel Heron-Vortes <m.emmanuel.heron@gmail.com>"
LABEL description="Docker image for Shibboleth Identity Provider v5 running on Apache Tomcat."

# Install OpenJDK 17 and other necessary packages
RUN apt-get update -q && \
    apt-get install -yq openjdk-17-jdk wget xmlstarlet unzip

# Define build arguments for versions and sensitive data
ARG TOMCAT_VERSION=10.1.18
ARG SHIBBOLETH_VERSION=5.0.0

# Download and install Apache Tomcat
RUN cd /tmp && \
    wget https://downloads.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Set environment variables for Java and Tomcat
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH

# Download and install Shibboleth Identity Provider
WORKDIR /opt
RUN wget "https://shibboleth.net/downloads/identity-provider/latest/shibboleth-identity-provider-${SHIBBOLETH_VERSION}.tar.gz" && \
    tar -zxvf "shibboleth-identity-provider-${SHIBBOLETH_VERSION}.tar.gz" && \
    rm "shibboleth-identity-provider-${SHIBBOLETH_VERSION}.tar.gz"

# Copy the properties file
COPY idp.properties /opt/shibboleth-idp-install.properties

# Install Shibboleth IDP and generate idp.war
RUN chmod +x /opt/shibboleth-identity-provider-${SHIBBOLETH_VERSION}/bin/install.sh && \
    /opt/shibboleth-identity-provider-${SHIBBOLETH_VERSION}/bin/install.sh \
    --propertyFile /opt/shibboleth-idp-install.properties && \
    cp /opt/shibboleth-idp/war/idp.war /opt/tomcat/webapps/

# Download JSTL JAR files to Tomcat's lib directory
RUN wget -P /opt/tomcat/lib/ https://repo.maven.apache.org/maven2/jakarta/servlet/jsp/jstl/jakarta.servlet.jsp.jstl-api/3.0.0/jakarta.servlet.jsp.jstl-api-3.0.0.jar \
    && wget -P /opt/tomcat/lib/ https://repo.maven.apache.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar


# Clean up installation files to reduce image size
RUN rm -rf "/opt/shibboleth-identity-provider-${SHIBBOLETH_VERSION}"

# Define volumes for logs, metadata, and configuration
VOLUME ["/opt/tomcat/logs", "/opt/tomcat/conf", "/opt/shibboleth-idp/conf", "/opt/shibboleth-idp/logs", "/opt/shibboleth-idp/metadata", "/opt/shibboleth-idp/conf"]

# Expose the ports Tomcat and Shibboleth IdP are running on
EXPOSE 8443 8080 443

# Copy the start script to the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set the container's default command to run the start script
ENTRYPOINT ["/start.sh"]

