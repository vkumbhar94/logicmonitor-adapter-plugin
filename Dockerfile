#FROM golang:1.14 as build
FROM python:2.7-slim as build
RUN apt-get update && yes | apt-get install curl gcc
#RUN curl -L -o golang.tar.gz https://golang.org/dl/go1.14.0.linux-amd64.tar.gz && tar -C /usr/local -xzf golang.tar.gz
RUN curl -L -o golang.tar.gz https://golang.org/dl/go1.14.13.linux-amd64.tar.gz && tar -C /usr/local -xzf golang.tar.gz

WORKDIR $GOPATH/src/github.com/vkumbhar94/logicmonitor-adapter-plugin
ARG VERSION
ENV PATH="${PATH}:/usr/local/go/bin"
RUN go version
COPY ./ ./
RUN go mod vendor
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -trimpath -o /logicmonitor.so --buildmode=plugin  .

FROM python:2.7-slim
LABEL maintainer="LogicMonitor <argus@logicmonitor.com>"
#RUN apk --update add ca-certificates \
#    && rm -rf /var/cache/apk/* \
#    && rm -rf /var/lib/apk/*
#WORKDIR /app
COPY --from=build /logicmonitor.so /bin