FROM image-registry.openshift-image-registry.svc:5000/openshift/nginx

LABEL "io.openshift.build.image"="image-registry.openshift-image-registry.svc:5000/openshift/nginx" \ 
      "io.openshift.build.source-location"="/tmp/build/inputs"

COPY ./s2i/bin/ /usr/libexec/s2i

USER 1001

RUN if [ -s /usr/libexec/s2i/save-artifacts ]; then /usr/libexec/s2i/save-artifacts > /tmp/artifacts.tar; else touch /tmp/artifacts.tar; fi

RUN /usr/libexec/s2i/assemble

FROM registry.redhat.io/rhscl/nginx-${APP_NGINX_VERSION}-rhel7 AS cached

FROM image-registry.openshift-image-registry.svc:5000/${APP_NAMESPACE}/${APP_APPLICATION_NAME}-builder AS build

USER root

COPY --from=cached /tmp/artifacts.tar /tmp/artifacts.tar

COPY --from=build /opt/app-root/src/${APP_OUTPUT_DIR}/. /tmp/src

COPY --from=build /opt/app-root/src/.sh/. /tmp/env

USER 1001

RUN if [ -s /tmp/artifacts.tar ]; then mkdir -p /tmp/artifacts; tar -xf /tmp/artifacts.tar -C /tmp/artifacts; fi && rm /tmp/artifacts.tar

RUN ["/bin/sh", "-c", "export $APP_ENV; envsubst < /opt/app-root/src/assets/env.template.js > /opt/app-root/src/assets/env.js;"]

CMD /usr/libexec/s2i/run