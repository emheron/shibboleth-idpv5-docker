# Shibboleth Identity Provider v5 Docker Image

## Introduction
This Docker image provides a basic setup for Shibboleth Identity Provider v5 running on Apache Tomcat, based on the latest Ubuntu LTS image. It's designed to be a starting point for setting up a Shibboleth IdP environment.

## Prerequisites
- Docker installed on your system.
- Basic understanding of Docker, Shibboleth IdP, and Apache Tomcat.

## Quick Start
1. **Clone the Repository:**
   ```
   git clone https://github.com/emheron/shibboleth-idpv5-docker.git
   cd shibboleth-idpv5-docker
   ```

2. **Build the Docker Image:**
   ```
   docker build -t shibboleth-idpv5 .
   ```

3. **Run the Container:**
   ```
   docker run -d -p 8080:8080 -p 8443:8443 shibboleth-idpv5
   ```

## Configuration
- **idp.properties**: This file contains the configuration for Shibboleth IdP. You must update this file according to your organization's requirements.

- **start.sh**: This script is executed when the container starts. It initializes Tomcat and applies necessary configurations.

- **SSL Configuration**: To enable SSL, follow these steps:
  1. Generate SSL certificates.
  2. Update the Dockerfile or startup script to include the SSL configuration for Tomcat.

## Volumes
The following volumes are defined in the Dockerfile:
- `/opt/shibboleth-idp/logs`: IdP log files.
- `/opt/tomcat/logs`: Tomcat log files.
- `/opt/shibboleth-idp/metadata`: Metadata files.
- `/opt/shibboleth-idp/conf`: IdP Configuration files.
- `/opt/tomcat/conf`: Tomcat Configuration files.

## Ports
The container exposes the following ports:
- `8080`: HTTP port for Apache Tomcat.
- `8443`: HTTPS port for Apache Tomcat.

## Customization
You can customize the Dockerfile and associated scripts to fit your specific requirements. This might include advanced IdP configurations, integration with external services, etc.

## Maintaining the Image
- Regularly check for updates to Ubuntu, Tomcat, Java, and Shibboleth IdP.
- Apply security patches and updates as needed.

## Support
For issues, suggestions, or contributions, please use the repository's issue tracker or submit a pull request.
