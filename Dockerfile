FROM debian:stretch

ENV DEBEMAIL="test@example.com" \
    DEBFULLNAME="John Doe" \
    DEBCHANGE_TZ="Europe/Berlin" \
    QUILT_PATCHES="debian/patches" \
    QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"

VOLUME /opt/buildroot

RUN apt-get update && apt-get install -y --no-install-recommends \
    debhelper \
    dpkg-dev \
    devscripts \
    equivs \
    quilt \
    build-essential \
    dput \
    vim \
    locales \
    openssh-client \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV USER=root LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Add backports repo
RUN echo 'deb http://cloudfront.debian.net/debian/ stretch-backports main contrib non-free' >> /etc/apt/sources.list

COPY build.sh /usr/local/bin/build.sh
RUN chmod +x /usr/local/bin/build.sh
USER root
