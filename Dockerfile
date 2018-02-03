FROM ubuntu
RUN apt-get update && apt-get install wget curl -y
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
RUN mv jq-linux64 jq && chmod a+x jq && mv jq /usr/bin
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kubectl &&  chmod +x ./kubectl && mv ./kubectl /usr/local/bin
COPY updater.sh /
CMD /updater.sh
