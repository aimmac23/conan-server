FROM debian:trixie-slim as builder

RUN apt-get update && apt-get install -y pip python3 git python3-venv  && rm -rf /var/lib/apt/lists/*

ADD do-pyinstaller-build.sh .
RUN ./do-pyinstaller-build.sh



FROM debian:trixie-slim

COPY --from=builder conan/dist/conan_server/_internal ./_internal
COPY --from=builder conan/dist/conan_server/conan_server .


EXPOSE 9300
STOPSIGNAL SIGINT
CMD ["./conan_server"]
