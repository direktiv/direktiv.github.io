FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Etc/UTC

RUN apt-get update
RUN apt-get install python3 python3-pip -y
RUN pip3 install mkdocs && \
    pip3 install mkdocs-material && \
    pip3 install mkdocs-render-swagger-plugin && \
    pip install mkdocs-awesome-pages-plugin && \
    pip3 install pymdown-extensions && \
    pip3 install mkdocs-material

CMD ["mkdocs", "serve", "-f", "/docs/page/mkdocs.yml", "-a", "0.0.0.0:8000"]