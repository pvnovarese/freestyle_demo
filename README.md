simple demo for connecting jenkins to anchore enterprise 

For a Freestyle job, I have the following build steps:

1) Execute Shell
```
docker build -t docker.io/pvnovarese/freestyle_demo:${BUILD_ID} .
echo "docker.io/pvnovarese/freestyle_demo:${BUILD_ID} Dockerfile" > anchore_images
```

2) Execute Docker Command (via docker-build-step plugin)
* Docker command: Push image
* Name of the image to push (repository/image): pvnovarese/freestyle_demo
* Tag: $BUILD_ID
* Registry: docker.io
* Docker registry URL: docker.io
* Registry credentials: (credential ID for docker hub user/pass)

3) Anchore Container Image Scanner (via anchore plugin)
* Image list file: anchore_images
* Fail build on policy evaluation FAIL result: (YES)
* Fail build on critical plugin error: (YES)
* Anchore Engine operation retries: 300
* Anchore Engine policy bundle ID: (blank - unnecessary for enterprise)
* Anchore Engine image annotations: (none)
* Anchore Engine auto-subscribe tag updates: (YES)
* Anchore Engine force image analysis: (YES - necessary if passing Dockerfile to analyzer)

4) Execute Docker Command
* Tag image
* Name of the image to tag (repository/image:tag): docker.io/pvnovarese/freestyle_demo:$BUILD_ID
* Target repository of the new tag: docker.io/pvnovarese/freestyle_demo
* The tag to set: prod

5) Execute Docker Command
* Docker command: Push image
* Name of the image to push (repository/image): pvnovarese/freestyle_demo
* Tag: prod
* Registry: docker.io
* Docker registry URL: docker.io
* Registry credentials: (credential ID for docker hub user/pass)
