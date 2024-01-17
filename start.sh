#!/bin/bash

# Set environment variables for Java and Tomcat
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export CATALINA_HOME=/opt/tomcat
export PATH=$CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH

# Start Apache Tomcat
echo "Starting Tomcat..."
/opt/tomcat/bin/startup.sh

# Wait for Tomcat to deploy applications
sleep 10

# Log that Tomcat has started
echo "Tomcat started."

# Keep the container running
tail -f /dev/null

