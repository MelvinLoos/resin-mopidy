FROM armhf/alpine:edge

MAINTAINER Melvin Loos <melvin@looselycoupled.nl>

ENV SPOTIFY_USERNAME username
ENV SPOTIFY_PASSWORD password

# Install packages.
RUN apk add --update \
        --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
        python2 python2-dev \
        py-six \
        py-gobject py-gobject-dev \
        py-gst0.10 \
	gstreamer1 gstreamer1-tools \
        gst-plugins-base1 gst-plugins-good1 gst-plugins-ugly1 \
        alsa-utils \
        py-pip && \
    rm -rf /var/cache/apk/*

# Server socket.
EXPOSE 6680

# Install Mopidy through pip
RUN pip install -U mopidy

# Install more Mopidy extensions from PyPI.
RUN pip install Mopidy-MusicBox-Webclient
RUN pip install Mopidy-Mobile

# Add the configuration file.
RUN mkdir -p /root/.config/mopidy
ADD mopidy.conf /root/.config/mopidy/mopidy.conf
# Find and replace placeholders with environment variables
RUN sed -i.bak \
    -e "s/{{ spotify.username }}/$SPOTIFY_USERNAME/g" \
    -e "s/{{ spotify.password }}/$SPOTIFY_PASSWORD/g" \
    /root/.config/mopidy/mopidy.conf;

CMD ["mopidy"]
