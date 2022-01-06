# Container image that runs your code
FROM asciidoctor/docker-asciidoctor:latest

RUN apk update && apk upgrade && apk add gcc musl-dev rustup
RUN rustup-init -y
RUN mkdir -p /src/svgbob \
        && cd /src/svgbob \
        && wget https://github.com/ivanceras/svgbob/archive/refs/tags/0.5.5.tar.gz -O svgbob \
        && tar -xf svgbob \
        && cd svgbob-0.5.5/ \ 
        && ~/.cargo/bin/cargo build --release -p svgbob_cli
RUN cp /src/svgbob/svgbob-0.5.5/target/release/svgbob /usr/bin
RUN apk add npm
RUN npm install -g bytefield-svg

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
