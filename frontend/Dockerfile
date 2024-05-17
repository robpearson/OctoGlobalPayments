# Use a lightweight Node.js image
FROM node:alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

RUN apk add curl

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 3000 (the port your Node.js application listens on)
EXPOSE 80

# Command to run the Node.js application
CMD ["node", "server.js"]