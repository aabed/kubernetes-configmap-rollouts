FROM alpine
RUN apk upgrade --update && \
     apk add curl bash coreutils jq

RUN curl -LO https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    mv jq-linux64 jq && chmod +x jq && mv jq /usr/local/bin && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/local/bin
COPY updater.sh /
CMD /updater.sh
