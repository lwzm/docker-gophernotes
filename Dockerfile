FROM golang:alpine as base

RUN apk add git gcc musl-dev zeromq-dev \
    && go version \
    && go get -v -ldflags "-s -w" github.com/gopherdata/gophernotes

FROM lwzm/jupyter
LABEL maintainer="lwzm@qq.com"

COPY --from=base /go/bin/gophernotes /usr/bin
COPY --from=base /go/src/github.com/gopherdata/gophernotes/kernel /usr/share/jupyter/kernels/gophernotes
