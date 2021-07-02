FROM node:12-alpine as base
WORKDIR /app/
COPY package*.json /app/

FROM base as dependencies
ENV NODE_ENV=development
WORKDIR /app/
RUN npm install --production

FROM dependencies as build
WORKDIR /app/
COPY . .
ENV NODE_ENV=production
RUN npm run build

FROM node:12-alpine
WORKDIR /app/
COPY --from=build /app/build build/
COPY --from=build /app/node_modules/ node_modules
COPY --from=build /app/server.js ./server.js
EXPOSE 9000
CMD ["node", "server.js"]