# Use a lightweight Node.js image
FROM node:alpine

# Set the working directory in the container
WORKDIR /usr/src/app09

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the API server files
COPY server.js .

run wget --no-check-certificate https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem -O /var/DigiCertGlobalRootCA.crt.pem

# Expose port 3000
EXPOSE 3000

# Set environment variables
ENV MYSQL_HOST=localhost
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=
ENV MYSQL_DATABASE=products

# Start the API server
CMD ["node", "server.js"]