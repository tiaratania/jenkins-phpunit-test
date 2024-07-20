# Jenkins Dockerfile
FROM jenkins/jenkins:lts

USER root

# Install prerequisites
RUN apt-get update && \
    apt-get install -y software-properties-common gnupg2

# Add repository for PHP 8.1
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/php.list && \
    apt-get update

# Install Python, Docker CLI, Git, PHP, and other dependencies
RUN apt-get install -y python3 python3-pip python3-venv docker.io git curl unzip && \
    apt-get install -y php8.1-cli php8.1-mbstring php8.1-curl php8.1-xml && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Install docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

# Add Jenkins user to Docker group (without creating it)
RUN usermod -aG docker jenkins

# Copy entrypoint script
COPY jenkins_entrypoint.sh /usr/local/bin/jenkins_entrypoint.sh
RUN chmod +x /usr/local/bin/jenkins_entrypoint.sh  

USER jenkins
