FROM alpine:3.23.5 as builder

RUN apk --no-cache add binutils python3 git

ADD do-pyinstaller-build.sh .
RUN ./do-pyinstaller-build.sh



FROM alpine:3.23.5

COPY --from=builder conan/dist/conan_server/_internal ./_internal
COPY --from=builder conan/dist/conan_server/conan_server .


EXPOSE 9300
STOPSIGNAL SIGINT
CMD ["./conan_server"]
