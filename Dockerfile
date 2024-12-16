FROM node:22.11.0-alpine

WORKDIR /aspo_api

COPY package.json .

RUN npm install

COPY . .

EXPOSE 5174

CMD [ "npm", "run", "start" ]