#!/bin/bash

apt update
apt install samba -y

read -p "Usuário do sistema que vai acessar a pasta: " USERNAME

if ! id "$USERNAME" &>/dev/null; then
  echo "Usuário '$USERNAME' não existe. Cria ele antes com adduser."
  exit 1
fi

smbpasswd -a "$USERNAME"

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
   valid users = $USERNAME
EOF

systemctl restart smbd

IP=$(hostname -I | awk '{print $1}')
echo "Acesse: smb://$IP/arquivos"
echo "Usuário: $USERNAME"

