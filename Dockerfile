# FROM debian:stable-slim

# RUN apt-get update && \
#     apt-get install -y apache2 && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# COPY index.html /var/www/html/

# EXPOSE 80

# CMD ["apache2ctl", "-D", "FOREGROUND"]


FROM public.ecr.aws/debian/apache2:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Copy custom configuration files if any
# COPY config/apache2.conf /etc/apache2/apache2.conf

COPY index.html /var/www/html/

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
#CMD ["sleep", "infinity"]
# End of Dockerfile