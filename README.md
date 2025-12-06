# Conan Server Docker Image and Kubernetes Helm Chart

This repo contains the Dockerfile definition for [Conan Server](https://docs.conan.io/2/reference/conan_server.html)

Docker Hub: https://hub.docker.com/r/aimmac23/conan-server

Helm Chart: https://artifacthub.io/packages/helm/conan-server/conan-server

## Docker Image

The image can be run using:

    docker run -p 9300:9300 aimmac23/conan-server:latest

Some volume mounting may be required to pass in the configuration file. Using the Helm Chart is recommended if possible.

## Helm Chart

Note that this Helm chart is primarily targeted to accelerating container-based build pipelines as a write-back cache, and not for persistent Conan package distribution. The permissioning is far too trivial for anything else, and will likely be a security vulnerability. The [Conan documentation recommends Artifactory](https://docs.conan.io/2/reference/conan_server.html] (or similar)

Persistent Volumes not currently supported in this Helm chart, so it currently drops the cached packages on restart.

### Installing

Add the Helm repo:

    helm repo add conan https://aimmac23.github.io/conan-server/
    helm repo update

Confgure the helm chart overrides.yaml file:

    # Expose the Service externally to the cluster on port 9300. By default uses ClusterIP.
    service:
        type: LoadBalancer
        port: 9300

    # Specify credentials for downloads/uploads. Technically multiple users are supported by the config, but the Helm interpolation errors out
    configFile:
        users: defaultUser:Password

Install the chart:

    helm install -f overrides.yaml conan conan/conan-server

## Using Conan Server

Before running your build, tell Conan about the local Conan Server:

    conan remote add local-cache http://$CONAN_HOST:9300
    conan remote login -p $CONAN_PASSWORD local-cache $CONAN_USERNAME

Then run the Conan build for the dependencies (project-dependent):

    conan install --build=missing ..

After the dependencies have compiled, then propagate any built packages back to the Conan Server:

      conan upload -r local-cache --confirm "*"

And then build your project code (project-dependent):

    cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake  -DCMAKE_BUILD_TYPE=Release
