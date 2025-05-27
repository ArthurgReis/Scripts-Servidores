#!/bin/bash

# Corrige travamentos do dpkg
echo "Corrigindo dpkg (se necessário)..."
dpkg --configure -a
apt install -f -y

# Atualiza repositórios e pacotes
apt update && apt upgrade -y

# Instala Apache, PHP, MariaDB e Python
apt install apache2 mariadb-server php libapache2-mod-php php-mysql python3 -y

# Inicia e habilita serviços
systemctl enable apache2
systemctl enable mariadb
systemctl start apache2
systemctl start mariadb

# Ativa CGI para Python
apt install apache2-bin -y
a2enmod cgi
systemctl restart apache2

# Cria diretório /var/www/html se não existir
mkdir -p /var/www/html

# Teste PHP
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Teste MySQL via PHP
cat <<EOF > /var/www/html/testemysql.php
<?php
\$mysqli = new mysqli("localhost", "root", "");
if (\$mysqli->connect_error) {
    die("Erro: " . \$mysqli->connect_error);
}
echo "Conexão MySQL OK";
?>
EOF

# Teste Python via CGI
mkdir -p /usr/lib/cgi-bin
cat <<EOF > /usr/lib/cgi-bin/test.py
#!/usr/bin/env python3
print("Content-type: text/html\n")
print("<html><body><h1>Python OK</h1></body></html>")
EOF

chmod +x /usr/lib/cgi-bin/test.py

echo "Instalação concluída."
echo "Testes disponíveis:"
echo "  PHP:        http://localhost/info.php"
echo "  MySQL/PHP:  http://localhost/testemysql.php"
echo "  Python CGI: http://localhost/cgi-bin/test.py"
