FROM node:16-alpine AS build

RUN apk --no-cache add git \
    && mkdir /app

WORKDIR /app

RUN git clone https://github.com/ChriZZ2406/Abschlussprojekt-Front-Backend Frontend \
    && cd Frontend \
    && npm install \
    && npm ci \
    && npm run build

# Stage 2: Final Image
FROM nginx:alpine

COPY --from=build /app/Frontend/dist /usr/share/nginx/html

EXPOSE 80


FROM  <DockerHub-UserName>/ansible-in-containers

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash","/entrypoint.sh"]