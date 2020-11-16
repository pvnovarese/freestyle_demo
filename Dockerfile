FROM alpine:latest


# GOOD dockerfile
EXPOSE 9999
# RUN apk add bash
# USER 65534:65534
# HEALTHCHECK NONE

# BAD dockerfile
# note that with no USER directive the default is 0 (root)
# EXPOSE 22
RUN apk add curl


CMD /bin/sh
