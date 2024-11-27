FROM python:3.10-slim

# Set username as a variable
ENV USER=username

# Install dependencies
RUN apt-get update && apt-get install -y \
    redis-server \
    supervisor && \
    apt-get clean

# Set working directory
WORKDIR /django_project

# Install Python dependencies
COPY requirements.txt /django_project/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /django_project/

# Copy supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the application port
EXPOSE 8000

# Add the user with user id 1000
RUN useradd -u 1000 $USER

# Change ownership of your code to your new user
RUN chown -R $USER:$USER /etc/supervisor/conf.d/supervisord.conf
RUN chown -R $USER:$USER /django_project
RUN chown -R $USER:$USER /var/log/supervisor/
RUN chmod +x /django_project/start-script.sh

# Make sure the container is running as non-root
USER $USER

# Start supervisord
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
