FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Etc/UTC

RUN apt-get update
RUN apt-get install python3 python3-pip -y
RUN pip3 install mkdocs && \
    pip3 install mike && \
    pip3 install mkdocs-material

RUN apt-get install wget git make jq golang-1.16 -y
RUN wget https://github.com/go-swagger/go-swagger/releases/download/v0.29.0/swagger_linux_amd64
RUN mv swagger_linux_amd64 /usr/local/bin/swagger && chmod +x /usr/local/bin/swagger

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \ 
    chmod a+x /usr/local/bin/yq 

ENV PATH=$PATH:/usr/lib/go-1.16/bin
WORKDIR /mydocs

RUN git config --global user.name = "Direktiv Build Bot"
RUN git config --global user.mail = "info@direktiv.io"
