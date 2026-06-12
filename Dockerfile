# Use official Node.js LTS image
FROM node:18-alpine

# Install dependencies needed for npm install
RUN apk add --no-cache python3 make g++

# Accept build arguments and set as environment variables
ARG PORT=4600
ARG NODE_ENV=production

# Frontend build arguments (from GitLab CI)
ARG VITE_APP_VERSION
ARG VITE_APP_API_SERVER

# Backend application environment variables
ARG JWT_EXPIRY
ARG JWT_SECRET
ARG BASE_URL
ARG REDIS_URL
ARG MONGO_URI
ARG GOOGLE_CREDENTIALS_B64
ARG TERMII_API_KEY
ARG GOOGLE_CREDENTIALS_PATH
ARG GOOGLE_SCOPES_API
ARG GOOGLE_CLIENT_ID
ARG STRIPE_KEY
ARG SENDER_ID
ARG MAILGUN_FROM_EMAIL
ARG MAILGUN_DOMAIN
ARG MAILGUN_SECRET_KEY
ARG AZURE_STORAGE_CONNECTION_STRING
ARG ACCESS_SECRET
ARG PASSWORD_CHANGE_SECRET
ARG PASSWORD_RESET_SECRET
ARG VERIFY_EMAIL_SECRET
ARG ACCESS_TOKEN_EXPIRES_AT_IN_SECONDS
ARG ENCRYPTION_KEY

# Only set non-sensitive environment variables
ENV PORT=$PORT \
    NODE_ENV=$NODE_ENV \
    VITE_APP_VERSION=$VITE_APP_VERSION \
    VITE_APP_API_SERVER=$VITE_APP_API_SERVER

# Set sensitive environment variables at runtime (not in ENV instruction)
# These will be passed as environment variables by the container runtime

# Set working directory
WORKDIR /app

# COPY google-credentials.json /app/google-credentials.json
# Copy package files first for better caching
COPY package*.json ./

# Copy the rest of the application code
COPY . .

# Install dependencies and build the NestJS application
RUN npm install --legacy-peer-deps && npx @nestjs/cli build

# Remove dev dependencies to reduce image size
RUN npm prune --production --legacy-peer-deps

# Create startup script to decode Google credentials
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'echo $GOOGLE_CREDENTIALS_B64 | base64 -d > /app/credential.json' >> /app/start.sh && \
    echo 'npm run start:prod' >> /app/start.sh && \
    chmod +x /app/start.sh

# Expose the backend port
EXPOSE 4600

# Start the server
CMD ["/app/start.sh"] 