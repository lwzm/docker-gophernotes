FROM alpine as base

RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories \
    && apk add --no-cache \
        git \
        pkgconfig \
        zeromq-dev \
        musl-dev \
        go \
    && go version \
    && go get -v -ldflags "-s -w" github.com/gopherdata/gophernotes \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r ~/go/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes


FROM alpine

RUN apk add --no-cache python3 py3-zmq \
    && pip3 install --no-cache-dir jupyter \
    && find /usr/lib/ -name '*.pyc' -delete

#ENV GOPATH=/go GO111MODULE=on GOPROXY=https://goproxy.io
#RUN apk add --no-cache -X http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community go

COPY jupyter /root/.jupyter
COPY --from=base /root/go/bin/gophernotes /usr/bin
COPY --from=base /root/.local /root/.local

EXPOSE 8888

VOLUME /home
WORKDIR /home

CMD [ "jupyter", "notebook" ]
