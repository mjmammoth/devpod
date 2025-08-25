# Start with minimal Debian
FROM debian:bookworm-slim

# Environment settings
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages + openssh + sudo + dependencies
RUN apt-get update && apt-get install -y \
  curl \
  git \
  openssh-server \
  sudo \
  bash \
  ca-certificates \
  fuse \
  unzip \
  rsync \
  jq \
  && apt-get clean

# Create dev user
RUN useradd -m -s /bin/bash dev && echo "dev:dev" | chpasswd && adduser dev sudo

# Set up SSH
RUN mkdir /var/run/sshd && \
  echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
  echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
  echo 'UsePAM no' >> /etc/ssh/sshd_config

# Install tenv
RUN LATEST_VERSION=$(curl --silent https://api.github.com/repos/tofuutils/tenv/releases/latest | jq -r .tag_name) && \
  curl -O -L "https://github.com/tofuutils/tenv/releases/latest/download/tenv_${LATEST_VERSION}_amd64.deb" && \
  sudo dpkg -i "tenv_${LATEST_VERSION}_amd64.deb"

RUN tenv tofu install 1.9.1
RUN tenv terragrunt install 0.81.0

# Set working dir
WORKDIR /home/dev/work
RUN chown dev:dev /home/dev/work

# Expose SSH port
EXPOSE 22

# Default command: start SSH
CMD ["/usr/sbin/sshd", "-D"]

