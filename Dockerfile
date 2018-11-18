# FROM python:3.6-slim
FROM sbneto/phusion-python:3.6
CMD ["/sbin/my_init"]
SHELL ["/bin/bash", "-c"]

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  openssh-client \
  graphviz-dev \
  pkg-config \
  git-core \
  openssl \
  libssl-dev \
  libffi6 \
  libffi-dev \
  libpng-dev \
  curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir /app

WORKDIR /app
ADD models /models
COPY requirements.txt Makefile stories.md nlu_data.md nlu_tensorflow.yml default_config.yml domain.yml ./

RUN  pip install -r requirements.txt
ADD . .
VOLUME ["/app/models", "/app/config", "/app/project"]
EXPOSE 5005

# ENTRYPOINT ["./entrypoint.sh"]
# CMD ["start", "-d", "./dialogue"]

CMD ["make","api"]

