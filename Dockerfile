FROM python:3.9-alpine3.13
LABEL maintainer="kevincashwell"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        #then /py/bin/pip install -r /tmp/requirements.txt; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; echo 'true'; \
        else echo 'false'; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

#RUN /py/bin/pip list

ENV PATH="/py/bin:$PATH"

USER django-user
