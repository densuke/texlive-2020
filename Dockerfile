FROM ubuntu:focal
COPY data/texlive.profile /tmp/

# ロケールとダウンロードの準備
RUN echo Asia/Tokyo > /etc/timezone; \
    apt update && apt install -y curl locales cpanminus; \
    sed -e 's;^# ja_JP.UTF-8;ja_JP.UTF-8;' -i /etc/locale.gen ; \
    echo 'LANG=ja_JP.UTF-8' > /etc/profile.d/locale.sh

# TeXLive インストーラーの入手と展開
RUN mkdir /tmp/texlive; cd /tmp/texlive; \
    curl -sL http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz; \
    mv /tmp/texlive.profile .; \
    cd install-tl-*; \
    perl install-tl --profile /tmp/texlive/texlive.profile; \
    echo "TEXLIVE_HOME=/usr/local/texlive/2020; export TEXLIVE_HOME" > /etc/profile.d/texlive.sh; \
    echo "PATH=${TEXLIVE_HOME}/bin/x86_64-linux:$PATH" >> /etc/profile.d/texlive.sh

ENV TEXLIVE_HOME=/usr/local/texlive/2020
ENV PATH=${TEXLIVE_HOME}/bin/x86_64-linux:$PATH
