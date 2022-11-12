# python:3.6-alpine with GEOS, GDAL, and Proj installed (built as a separate image
# because it takes a long time to build)
#FROM rapidpro/rapidpro-base:v4
FROM alpine:latest
ARG COURIER_VERSION

# TODO determine if a more recent version of Node is needed
# TODO extract openssl and tar to their own upgrade/install line
# Install `psql` command (needed for `manage.py dbshell` in stack/init_db.sql)
# Install `libmagic` (needed since rapidpro v3.0.64)

RUN apk --no-cache update
RUN apk add --no-cache wget netcat-openbsd bash libc6-compat tzdata


WORKDIR /usr/bin

RUN echo "Downloading COURIER ${COURIER_VERSION}" 
RUN wget  "https://github.com/nyaruka/courier/releases/download/v${COURIER_VERSION}/courier_${COURIER_VERSION}_linux_amd64.tar.gz" 
RUN tar -xvzf courier_${COURIER_VERSION}_linux_amd64.tar.gz
RUN rm courier_${COURIER_VERSION}_linux_amd64.tar.gz
RUN ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
EXPOSE 8080

LABEL org.label-schema.name="COURIER" \
      org.label-schema.description="Courier is a messaging gateway for text-based messaging channels. It abstracts out various different texting mediums and providers, allowing applications to focus on the creation and processing of those messages." \
      org.label-schema.url="https://rapidpro.github.io/rapidpro/docs/courier/" \
      org.label-schema.vcs-url="https://github.com/nyaruka/mailroom" \
      org.label-schema.vendor="Nyaruka, UNICEF, and individual contributors." \
      org.label-schema.version=$COURIER_VERSION \
      org.label-schema.schema-version=${COURIER_VERSION}

CMD ["courier", "-debug-conf"]
