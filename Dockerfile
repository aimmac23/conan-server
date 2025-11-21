FROM debian:trixie-slim

RUN apt-get update && apt-get install -y pip python3  && rm -rf /var/lib/apt/lists/*
RUN pip install --break-system-packages --no-cache-dir conan-server

EXPOSE 9300
CMD ["conan_server"]
