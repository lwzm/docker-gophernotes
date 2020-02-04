FROM alpine as base

#RUN apk add --no-cache -X http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community go

RUN apk add --no-cache \
        git \
        pkgconfig \
        zeromq-dev \
        musl-dev \
        go \
    && go version \
    && go get -v -ldflags "-s -w" github.com/gopherdata/gophernotes


FROM lwzm/jupyter

COPY --from=base /root/go/bin/gophernotes /usr/bin
COPY --from=base /root/go/src/github.com/gopherdata/gophernotes/kernel /usr/share/jupyter/kernels/gophernotes
