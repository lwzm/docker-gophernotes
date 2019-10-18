FROM alpine as base

ENV PATH=/root/.local/bin:${PATH} GOPATH=/go

RUN apk add --no-cache -X http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community \
        git \
        pkgconfig \
        zeromq-dev \
        musl-dev \
        go \
    && go version \
    && go get -u github.com/gopherdata/gophernotes \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes


FROM alpine

RUN apk add --no-cache python3 py3-zmq \
    && pip3 install jupyter \
    && find /usr/lib/ -name '*.pyc' -delete

#ENV GOPATH=/go GO111MODULE=on GOPROXY=https://goproxy.io
#RUN apk add --no-cache -X http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community go

COPY jupyter /root/.jupyter
COPY --from=base /go/bin/gophernotes /usr/bin
COPY --from=base /root/.local /root/.local

EXPOSE 8888

VOLUME /home
WORKDIR /home

CMD [ "jupyter", "notebook" ]
