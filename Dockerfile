FROM alpine:latest

# GOOD dockerfile
#EXPOSE 9999
#RUN apk add --no-cache vim
#USER 65534:65534
#HEALTHCHECK CMD /bin/true

# BAD dockerfile 
# Many policies block port 22 (sshd), block packages like curl or sudo,
# and scan for secrets like ssh keys etc.  Also many policies will flag
# things like no effective USER or HEALTHCHECK being defined.  You 
# should add whatever else you want to test from your policies here.
EXPOSE 22
RUN apk add --no-cache curl sudo
RUN echo "aws_access_key_id=01234567890123456789" > /aws_key && \
    echo "aws_secret_access_key=0123456789012345678901234567890123456789" > /aws_secret_key && \
    echo "--BEGIN PRIVATE KEY--" > /private_key && \
    echo "auth: \\"something\\"" > /docker_auth && \
    echo "api-key=00000000000000000000000" > /api_key

CMD /bin/sh
