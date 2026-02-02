FROM public.ecr.aws/debian/debian:stable-slim

# Install Apache
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apache2 \
      apache2-utils \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Enable useful modules
RUN a2enmod rewrite headers ssl proxy proxy_http deflate env expires mime setenvif

# Create directories and set permissions
RUN mkdir -p /var/run/apache2 /var/log/apache2 && \
    chown -R www-data:www-data /var/www/html /var/run/apache2 /var/log/apache2

# Copy a simple index.html
RUN echo '<h1>Hello from Apache Docker Container</h1>' > /var/www/html/index.html

# Set environment variables
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]