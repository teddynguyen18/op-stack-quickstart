FROM node:lts as builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --prod

FROM node:lts-slim

RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/node_modules /app/node_modules
COPY src ./src

CMD ["node", "src/index.js"]