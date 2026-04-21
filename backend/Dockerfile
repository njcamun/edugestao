FROM node:20-slim

# Instala o openssl que é necessário para o Prisma no Debian
RUN apt-get update -y && apt-get install -y openssl

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run prisma:generate

EXPOSE 3000
CMD ["npm", "run", "start:dev:docker"]
