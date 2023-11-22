FROM node:lts

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --prod
COPY src ./src

CMD ["node", "src/index.js"]