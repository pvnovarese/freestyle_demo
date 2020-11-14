simple demo for connecting jenkins to anchore enterprise 

Assumptions: 
* you've already got Anchore up and running
* you already have the Anchore Scanner plugin configured
* you've already got Jenkins configured to build docker images
* you have a stored credential with your Docker Hub username/password (or whatever registry you will be pushing your images to)

For a Freestyle job, you'll need to configure your job as follows:

1) **Source Code Management**
* git
* repository URL: https://github.com/pvnovarese/freestyle_demo (or whatever you cloned this to)
![Source Code Management Screenshot](/images/scm.png)


2) **Build Environment**
* Use secret text(s) or file(s) (YES)
* ADD "username and password (separated)"
* Username Variable: HUB_USER
* Password Variable: HUB_PASS
* Credentials: your stored credential ID
![Build Environment Screenshot](https://github.com/pvnovarese/freestyle_demo/blob/master/images/build_environment.png?raw=true)

I have the following build steps:

1) **Execute Shell**
```
# change REGISTRY to whatever Docker v2-compatible registry you want 
export REGISTRY=docker.io
# save registry so we can use it again later
echo ${REGISTRY} > .registry_name
# docker login
docker login -u ${HUB_USER} -p ${HUB_PASS} ${REGISTRY}
# build image to be tested with build ID as tag
docker build -t ${REGISTRY}/${HUB_USER}/freestyle_demo:${BUILD_ID} .
# construct the anchore_images file the plugin reads to know what to scan
echo ${REGISTRY}"/${HUB_USER}/freestyle_demo:${BUILD_ID} Dockerfile" > anchore_images
# push test image
docker push ${REGISTRY}/${HUB_USER}/freestyle_demo:${BUILD_ID}
```

2) **Anchore Container Image Scanner (via anchore plugin)**
* Image list file: anchore_images
* Fail build on policy evaluation FAIL result: (YES)
* Fail build on critical plugin error: (YES)
* Anchore Engine operation retries: 300
* Anchore Engine policy bundle ID: (blank - unnecessary for enterprise)
* Anchore Engine image annotations: (none)
* Anchore Engine auto-subscribe tag updates: (YES)
* Anchore Engine force image analysis: (YES - necessary if passing Dockerfile to analyzer)
![Anchore Plugin Config Screenshot](/images/anchore.png)

3) **Execute Shell**
```
# recover registry name from earlier
export REGISTRY=$(cat .registry_name)
# re-tag image as production now that it's passed our scan
docker tag ${REGISTRY}/${HUB_USER}/freestyle_demo:${BUILD_ID} ${REGISTRY}/${HUB_USER}/freestyle_demo:prod
# push production image
docker push ${REGISTRY}/${HUB_USER}/freestyle_demo:prod
```
