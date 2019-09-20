FROM alpine

ENV PATH=/root/.local/bin:${PATH} GOPATH=/go

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add \
        ca-certificates \
        python3 \
        su-exec \
        gcc \
        git \
        py3-zmq \
        pkgconfig \
        zeromq-dev \
        musl-dev \
    && (cd /usr/bin && ln -s python3 python) \
    ## install Go
    && apk -X http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community add go \
    ## jupyter notebook
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    && pip3 install --user jupyter notebook pyzmq ipykernel \
    ## install gophernotes
    && go get -u github.com/gopherdata/gophernotes \
    && cp /go/bin/gophernotes /usr/local/bin/ \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* ~/.local/share/jupyter/kernels/gophernotes \
    ## clean
    && find /usr/lib/python* -name __pycache__ | xargs rm -r \
    && rm -rf /var/cache/apk/*

COPY jupyter /root/.jupyter

EXPOSE 8888

ENV GO111MODULE=on GOPROXY=https://goproxy.io
VOLUME [ "/home" ]
WORKDIR /home

CMD [ "jupyter", "notebook" ]
