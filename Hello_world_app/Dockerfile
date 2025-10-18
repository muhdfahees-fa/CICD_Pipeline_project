# Base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy dependency files
COPY Hello_world_app/package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the app
COPY Hello_world_app/ ./

# Expose port
EXPOSE 8000

# Start the app
CMD ["npm", "start"]

