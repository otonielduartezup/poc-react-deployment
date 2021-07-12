FROM node:12-alpine as build
WORKDIR /app/
COPY package*.json /app/
ENV NODE_ENV=production
RUN npm install --production
COPY . .
RUN npm run build

#FROM node:12-alpine
#WORKDIR /app/
#COPY --from=build /app/build build/
#COPY --from=build /app/node_modules/ node_modules
#COPY --from=build /app/server.js ./server.js
#EXPOSE 9000
#CMD ["node", "server.js"]

FROM nginx:1.20.1-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]