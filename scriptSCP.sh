#!/bin/bash

verificar_ssh_instalado_local() {
	dpkg -l | grep -q openssh-client
}

verificar_ssh_instalado_remoto() {
	ssh -o BatchMode=yes -o ConnectTimeout=5 "$usuario@$ip" 'dpkg -l | grep -q openssh-server' &> /dev/null
}

instalar_ssh_local() {
	echo "O SSH não está instalado na máquina local. Instalando..."
	sudo apt update
	sudo apt install -y openssh-client
}

instalar_ssh_remoto() {
	echo "O SSH não está instalado na máquina remota. Instalando..."
	ssh "$usuario@$ip" 'sudo apt update && sudo apt install -y openssh-server'
}

echo "Digite o nome de usuário da máquina remota:"
read usuario

echo "Digite o IP da máquina remota:"
read ip

if ! verificar_ssh_instalado_local; then
	instalar_ssh_local
else
	echo "SSH já está instalado na máquina local."
fi

if ! verificar_ssh_instalado_remoto; then
	echo "SSH não está instalado na máquina remota."
	echo "Deseja instalar o SSH na máquina remota? (s/n)"
	read resposta
	if [ "$resposta" == "s" ]; then
    	instalar_ssh_remoto
	else
    	echo "Não foi possível continuar sem o SSH na máquina remota."
    	exit 1
	fi
else
	echo "SSH já está instalado na máquina remota."
fi

echo "Digite o caminho completo do arquivo remoto (ex: /home/usuario/arquivo.txt):"
read caminho_remoto

echo "Digite o caminho local onde deseja salvar o arquivo (ex: /home/usuario/Downloads/):"
read destino_local

echo "Você inseriu as seguintes informações:"
echo "Usuário: $usuario"
echo "IP: $ip"
echo "Caminho do arquivo remoto: $caminho_remoto"
echo "Caminho de destino local: $destino_local"
echo

scp "$usuario@$ip:$caminho_remoto" "$destino_local"

if [ $? -eq 0 ]; then
	echo "Arquivo copiado com sucesso!"
else
	echo "Erro ao copiar o arquivo."
fi



