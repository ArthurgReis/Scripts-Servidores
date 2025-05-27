#!/bin/bash

# Atualiza o sistema
apt update && apt upgrade -y

# Instala Apache, MariaDB, PHP
apt install apache2 mariadb-server php libapache2-mod-php php-mysql -y

# Ativa e inicia Apache e MariaDB
systemctl enable apache2 mariadb
systemctl start apache2 mariadb

# Ativa CGI para usar Python
a2enmod cgi
systemctl restart apache2

# Cria script de teste PHP
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Cria diretório CGI e script Python básico
mkdir -p /usr/lib/cgi-bin
cat <<EOF > /usr/lib/cgi-bin/test.py
#!/usr/bin/env python3
print("Content-type: text/html\n")
print("<html><body><h1>Python OK</h1></body></html>")
EOF

chmod +x /usr/lib/cgi-bin/test.py

# Cria script de teste MySQL em PHP (senha padrão: vazia)
cat <<EOF > /var/www/html/testemysql.php
<?php
\$mysqli = new mysqli("localhost", "root", "");
if (\$mysqli->connect_error) {
    die("Erro: " . \$mysqli->connect_error);
}
echo "Conexão MySQL OK";
?>
EOF

# Mensagem final
echo "Feito. Teste em: http://localhost/info.php | /cgi-bin/test.py | /testemysql.php"

