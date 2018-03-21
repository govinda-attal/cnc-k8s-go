
# FROM golang:1.10-alpine

# RUN apk -U add ca-certificates

# WORKDIR /app
# # Set an env var that matches your github repo name, replace treeder/dockergo here with your repo name
# ENV SRC_DIR=/go/src/application/
# # Add the source code:
# ADD . $SRC_DIR
# # Build it:
# RUN cd $SRC_DIR; go build -o app
# WORKDIR $SRC_DIR
# ENTRYPOINT ["./app"]

# # Expose your port
# EXPOSE 8080

# build stage
FROM golang:1.10-alpine AS build-env
ENV APP_NAME=goapp
ADD . /src
RUN cd /src && go build -o $APP_NAME

# final stage
FROM alpine:3.7
ENV APP_NAME=goapp
RUN apk -U add ca-certificates

WORKDIR /app
COPY --from=build-env /src/ /app/
ENTRYPOINT ./$APP_NAME
EXPOSE 8080
