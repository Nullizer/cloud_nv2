#!/bin/bash
env > /env.txt
cat << EOF > /etc/shadowsocks-rust/main-server.json
{
    "server":"0.0.0.0",
    "server_port":42424,
    "password":"$SS_PASS",
    "method":"$SS_METHOD",
    "plugin":"v2ray-plugin",
    "plugin_opts":"server;path=$V2_PATH"
}
EOF
sed -e "s|\${V2_PATH}|${V2_PATH}|g" \
    -i /etc/nginx/nginx.conf
