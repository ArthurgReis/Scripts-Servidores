#!/bin/bash

# Instala
sudo apt update
sudo apt install -y proftpd

# Escreve a config básica direto no arquivo
sudo tee /etc/proftpd/proftpd.conf > /dev/null <<EOF
ServerName                      "Servidor FTP"
ServerType                      standalone
DefaultServer                   on
Port                            21
Umask                           022
MaxInstances                    30
User                            proftpd
Group                           nogroup
DefaultRoot                     ~

RequireValidShell               off
AuthOrder                       mod_auth_unix.c

<Limit LOGIN>
  AllowAll
</Limit>

DisplayLogin                    welcome.msg
DisplayChdir                    .message

ExtendedLog                     /var/log/proftpd/access.log WRITE,READ default
SystemLog                       /var/log/proftpd/proftpd.log

<Anonymous ~ftp>
  User                         ftp
  Group                        nogroup
  UserAlias                    anonymous ftp
  RequireValidShell            off
  MaxClients                   5
  <Limit WRITE>
    DenyAll
  </Limit>
  <Limit READ>
    AllowAll
  </Limit>
</Anonymous>
EOF

# Cria o usuário FTP
sudo useradd -m -d /home/ftpuser -s /usr/sbin/nologin ftpuser
sudo passwd ftpuser

# Permissões básicas
sudo mkdir -p /home/ftpuser/files
sudo chown -R ftpuser:ftpuser /home/ftpuser
sudo chmod -R 755 /home/ftpuser

# Reinicia o serviço
sudo systemctl restart proftpd
sudo systemctl enable proftpd

