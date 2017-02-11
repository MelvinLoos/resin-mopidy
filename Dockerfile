FROM resin/rpi-buildpack-deps:jessie-curl

RUN wget -q -O - http://apt.mopidy.com/mopidy.gpg | apt-key add - \
  && wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    gstreamer1.0-alsa \
    gstreamer1.0-plugins-bad \
    mopidy \
    mopidy-soundcloud \
    mopidy-spotify \
    python-pip \
    python-pygame \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install \
  Mopidy-Moped \
  Mopidy-Touchscreen \
  Mopidy-Youtube

COPY start.sh /start.sh

# removes docs from image 
# see https://docs.resin.io/deployment/build-optimisation/#pro-tips-for-slimming-down-your-build
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/

CMD /start.sh