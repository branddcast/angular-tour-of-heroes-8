#------------------ DOCKER CONFIGURATION ------------------

# #Primera Etapa
FROM registry.access.redhat.com/ubi8/nodejs-14 as build-step

USER root

COPY upload/src /tmp/src

RUN chown -R 1001:0 /tmp/src

USER 1001

RUN /usr/libexec/s2i/assemble

CMD /usr/libexec/s2i/run

# #Segunda Etapa
FROM registry.access.redhat.com/ubi8/nginx-118

# Add application sources to a directory that the assemble script expects them
# and set permissions so that the container runs without root access

USER 1001

RUN if [ -s /usr/libexec/s2i/save-artifacts ]; then /usr/libexec/s2i/save-artifacts > /tmp/artifacts.tar; else touch /tmp/artifacts.tar; fi

USER root

COPY --from=build-step /tmp/artifacts.tar /tmp/artifacts.tar 

COPY upload/src /tmp/src

RUN chown -R 1001:0 /tmp/artifacts.tar /tmp/src

USER 1001

RUN if [ -s /tmp/artifacts.tar ]; then mkdir -p /tmp/artifacts; tar -xf /tmp/artifacts.tar -C /tmp/artifacts; fi &&     rm /tmp/artifacts.tar

RUN /usr/libexec/s2i/assemble

RUN /bin/sh -c source /opt/app-root/src/sh/$SH_FILE.sh; envsubst < /opt/app-root/src/assets/env.template.js > /opt/app-root/src/assets/env.js; rm -rf /opt/app-root/src/sh

CMD /usr/libexec/s2i/run


    # COPY upload/src /tmp/src

    #   RUN chown -R 1001:0 /tmp/artifacts.tar /tmp/src

    #   USER 1001

    #   RUN if [ -s /tmp/artifacts.tar ]; then mkdir -p /tmp/artifacts; tar -xf
    #   /tmp/artifacts.tar -C /tmp/artifacts; fi &&     rm /tmp/artifacts.tar

    #   RUN /usr/libexec/s2i/assemble

    #   RUN /bin/sh -c source /opt/app-root/src/sh/$SH_FILE.sh; envsubst <
    #   /opt/app-root/src/assets/env.template.js >
    #   /opt/app-root/src/assets/env.js; rm -rf /opt/app-root/src/sh

    #   CMD /usr/libexec/s2i/run