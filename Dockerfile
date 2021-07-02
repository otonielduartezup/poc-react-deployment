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

#FROM node:12-alpine
#WORKDIR /app/
#COPY --from=build /app/build build/
#COPY --from=build /app/node_modules/ node_modules
#COPY --from=build /app/server.js ./server.js
#EXPOSE 9000
#CMD ["node", "server.js"]

FROM nginx:1.17.8-alpine
COPY --from=build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]