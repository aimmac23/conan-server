# Conan Server Helm Chart

## Prerequisites

 - Kubernetes
 - Helm

## Intended Purpose

 - Container-based build pipelines, to cache compiled dependencies in the most Conan way possible
 - Low memory footprint environments (~30Mb) - Homelab on Raspberry Pis, etc
 - Local development in a team, or non-production builds

## Out of Scope

 - Any purpose that requires non-trivial security permissioning - use Artifactory for that.

## Installing

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

## Using Conan Server in builds

Before running your build, tell Conan about the local Conan Server:

    conan remote add local-cache http://$CONAN_HOST:9300
    conan remote login -p $CONAN_PASSWORD local-cache $CONAN_USERNAME

Then run the Conan build for the dependencies (project-dependent):

    conan install --build=missing ..

After the dependencies have compiled, then propagate any built packages back to the Conan Server:

      conan upload -r local-cache --confirm "*"

And then build your project code (project-dependent):

    cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake  -DCMAKE_BUILD_TYPE=Release
