ARG SYSBASE=almalinux/openqa:base-al9
FROM ${SYSBASE}
LABEL AUTHOR="Bala Raman <srbala@gmail.com>"
#
# OpenQA WebUI
#
RUN dnf install -y --nodocs \
    git-core openqa openqa-httpd git-core mod_ssl \
    nfs-utils perl-REST-Client python3-jsonschema \
    psmisc perl-Mojolicious-Plugin-OAuth2 withlock\
# should be able to run without these packages, enable if needed
#   openqa-local-db fedora-messaging python3-fedfind python3-openqa_client  && \
    python3-pip openqa-python-scripts ; \
    dnf clean all && \
    pip install --no-cache-dir pytest pytest-testinfra tox && \
    cd /var/lib/openqa ; \
# managed using volume, revisit if needed    
#    chown geekotest -R db images testresults webui share/*; \
    mv /etc/openqa/database.ini /etc/openqa/database.ini_orig ; \
    mv /etc/openqa/openqa.ini /etc/openqa/openqa.ini_orig ; \
# ssl config injected using volume mount
    mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf-orig ; \
    cp /etc/httpd/conf.d/openqa.conf.template /etc/httpd/conf.d/openqa.conf; 

COPY run_openqa.sh /usr/local/bin

# set-up shared data and configuration
RUN rm -rf /var/lib/openqa/share/factory /var/lib/openqa/share/tests \
    /var/lib/openqa/testresults /var/lib/openqa/images && \
    chmod +x /usr/local/bin/run_openqa.sh && \
    mkdir -p /var/lib/openqa/pool /var/log/openqa && \
    ln -s /data/factory /var/lib/openqa/share/factory && \
    ln -s /data/tests /var/lib/openqa/share/tests && \
    ln -s /data/testresults /var/lib/openqa/testresults && \
    ln -s /data/images /var/lib/openqa/images && \
    chown -R geekotest /usr/share/openqa /var/lib/openqa /var/log/openqa && \
    chmod ug+rw /usr/share/openqa /var/lib/openqa /var/log/openqa && \
    find /usr/share/openqa /var/lib/openqa /var/log/openqa -type d -exec chmod ug+x {} \;

RUN systemctl set-default multi-user.target; \
    systemctl enable openqa-scheduler; \
    systemctl enable openqa-websockets; \
    systemctl enable openqa-gru; \
    systemctl enable openqa-livehandler; \
    systemctl enable httpd; \
# enable this when/if fedora message enabled
#    systemctl enable fm-consumer@fedora_openqa_scheduler; \
    systemctl enable openqa-webui; 

EXPOSE 80 443 9526 9527 9528 9529
# CMD ["/usr/local/bin/run_openqa.sh"]
CMD ["/sbin/init"]