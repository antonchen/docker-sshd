FROM 0x416e746f6e0a/alpine-base:3.9

# set maintainer label
LABEL MAINTAINER="Anton Chen <contact@antonchen.com>"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
    iproute2 \
    openssh-server \
    openssh-client \
    rsync \
    augeas \
    curl \
    unrar \
    unzip \
    vim \
    zsh && \
 apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    lrzsz && \
 augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/ssh/keys/authorized_keys/%u"' && \
 curl -s -k https://raw.githubusercontent.com/antonchen/zshrc/master/install.sh | bash && \
 sed -i '/alias grep/d' /root/.zsh/alias.zsh && \
 sed -i "/alias lh/a\alias sz='lsz'" /root/.zsh/alias.zsh && \
 sed -i "/alias lh/a\alias rz='lrz'" /root/.zsh/alias.zsh && \
 curl -s -k https://raw.githubusercontent.com/antonchen/simple-vim/master/install.sh | bash && \
 sed -i "s/^let Author =.*\$/let Author = ''/g" /root/.vimrc && \
 echo "**** cleanup ****" && \
 rm -rf \
    /tmp/* \
    /var/cache/apk/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 22
VOLUME /etc/ssh/keys
