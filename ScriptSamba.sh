#!/bin/bash

apt update
apt install samba -y

read -p "Usuário do sistema que vai acessar a pasta: " USUARIO

if ! id "$USUARIO" &>/dev/null; then
  echo "Usuário '$USUARIO' não existe."
  exit 1
fi

smbpasswd -a "$USUARIO"

mkdir -p /compartilhado
chmod 777 /compartilhado

cp /etc/samba/smb.conf /etc/samba/smb.conf.bkp

cat <<EOF >> /etc/samba/smb.conf

[arquivos]
   path = /compartilhado
   browseable = yes
   read only = no
   writable = yes
   guest ok = no
   valid users = $USUARIO
EOF

systemctl restart smbd


