FROM python:3.10.0-bullseye

RUN pip install requests
RUN python3 -m pip install mkdocs-linkcheck

CMD ["mkdocs-linkcheck", "-r", "testsite"]
