# Use an official Node.js LTS image as the base
FROM node:lts

# Set the working directory inside the container
WORKDIR /opt/cronicle

# Install Cronicle dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install Cronicle
RUN curl -s https://raw.githubusercontent.com/jhuckaby/Cronicle/master/bin/install.js | node

# Expose the port on which Cronicle runs (3012)
EXPOSE 3012

# Set environment variable to indicate whether it's the primary server
ENV IS_PRIMARY_SERVER=true

ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV debug_level=1
ENV HOSTNAME=main

# Run Cronicle setup only on the primary server, and start the service on all servers
CMD ["/bin/bash", "-c", "if [ \"$IS_PRIMARY_SERVER\" = \"true\" ]; then /opt/cronicle/bin/control.sh setup; fi && /opt/cronicle/bin/control.sh start"]
