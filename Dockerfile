FROM node:18

# Create app directory
WORKDIR /usr/src/app

#install app dependanices
COPY package*.json ./

#Building our code for production 
RUN npm install

#Bundle app source
COPY . .

EXPOSE 8080
CMD ["node" ,"-jar","server.js"]
