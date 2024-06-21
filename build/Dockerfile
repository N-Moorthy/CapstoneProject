# Use the official Nginx image from the Docker Hub
FROM nginx:latest

# Copy static website files to the container
COPY . /usr/share/nginx/html

# Expose port 80 to allow external access
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

