FROM archlinux

ENV SS_PASS=defaultpassxQd
ENV SS_METHOD=aes-128-gcm
ENV V2_PATH=/v2api

RUN echo 'Server = https://mirror.redrock.team/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist \
  && echo '[archlinuxcn]' >> /etc/pacman.conf \
  && echo 'Server = https://repo.archlinuxcn.org/$arch' >> /etc/pacman.conf \
  && pacman -Sy && pacman-key --init \
  && pacman -S --noconfirm archlinuxcn-keyring \
  && pacman -S --noconfirm nginx shadowsocks-v2ray-plugin shadowsocks-rust-opt-git \
  && yes|pacman -Scc

RUN echo 'ForwardToConsole=yes' >> /etc/systemd/journald.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY before_start.sh /usr/local/bin/before_start.sh
COPY before_start.service /etc/systemd/system/before_start.service

RUN systemctl enable before_start.service nginx.service shadowsocks-rust-server@main-server.service

EXPOSE 80

CMD [ "/sbin/init" ]
