FROM node:18-alphine
#working directory
WORKDIR /usr/src/app

#copy packages files and install dependencies

COPY packages*.json ./
RUN npm install --only=production

#Copy rest of source code
COPY . .

Expose 8000
CMD["npm", "start"]
