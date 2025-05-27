#!/bin/bash

instalado=$(dpkg --get-selections | grep -c net-tools)
if [ "$instalado" -eq "0" ]; then
	sudo apt install net-tools
fi
echo "Configuração de rede"

sudo ifconfig
sleep 2
echo "Qual é a interface? "
read interface;
echo "Qual é o IP? "
read endereco_ip;
echo "Qual é a mascara de rede? "
read mascara;
echo "Qual é o gateway? "
read gway;
echo "Qual é o DNS1? "
read dns1;
echo "Qual é o DNS2? "
read dns2;

echo "Desativando a interface $interface..."
sudo ifconfig $interface down
echo "Adicionando mascara de rede..."
sudo ifconfig $interface $endereco_ip netmask $mascara up
sudo route add default gw $gway $interface

sudo echo "nameserver $dns1" > /etc/resolv.conf
sudo echo "nameserver $dns2" >> /etc/resolv.conf
Tutorial de Configuração de Rede Usando Script Bash 

Obs: Variáveis marcadas com “$” fornecidas pelo o usuário. 

Desativação da Interface de Rede: Antes de configurar uma interface de rede, é necessário desativar com ifconfig $interface down. Isso é importante porque não é possível reconfigurar corretamente uma interface ativa. Ao desativá-la, o script garante que as novas configurações sejam aplicadas sem interferência.


Configuração do Endereço IP e Máscara de Rede : Após desativar a interface, o script aplica o novo endereço IP e a máscara de rede, além de ativar a interface de rede com o comando:

sudo ifconfig $interface $endereco_ip netmask $mascara up

Definindo o Gateway: O script configura o gateway padrão com o comando:

sudo route add default gw $gway $interface

Configuração de DNS O script configura os servidores DNS diretamente no arquivo /etc/resolv.conf com os comandos:

sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf



