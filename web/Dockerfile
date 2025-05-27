# Stage 1: Build the Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.22.1 AS build

# Fix for running flutter commands as root inside Docker
RUN git config --global --add safe.directory /sdks/flutter

# Set the working directory inside the container
WORKDIR /app

# Copy all project files into the container
COPY . .

# Enable Flutter web support
RUN flutter config --enable-web

# Run flutter pub get to fetch dependencies
RUN flutter pub get

# Optional debug: Show that assets exist before building
RUN ls -R assets/

# Build the web app
RUN flutter build web

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy the built web output to nginx's html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 for web access
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
