# Étape 1 : Build Angular

FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx ng build --configuration production

# Étape 2 : Serve avec Nginx

FROM nginx:alpine
COPY --from=build /app/dist/mdops-frontend/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf  
EXPOSE 80