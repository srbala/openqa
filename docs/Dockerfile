FROM almalinux:9-minimal
LABEL MAINTAINER Bala Raman <srbala@gmail.com>

# add startup script
ADD entrypoint.sh /entrypoint.sh

RUN microdnf -y --setopt=tsflags=nodocs install httpd-core ; \
    microdnf clean all; \
    chmod -v +x /entrypoint.sh; \
    echo "<html><body>Apache up and running</body></html>" > /var/www/html/index.html

# Copy web contents
ADD assets/ /var/www/html/assets

EXPOSE 80
CMD [ "/entrypoint.sh" ]