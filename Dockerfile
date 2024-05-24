# Use an official Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    nodejs \
    npm

# Install Node.js version 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh

# Install GitHub Actions runner
RUN mkdir -p /actions-runner && \
    cd /actions-runner && \
    curl -o actions-runner-linux-x64-2.285.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.285.1/actions-runner-linux-x64-2.285.1.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.285.1.tar.gz

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
