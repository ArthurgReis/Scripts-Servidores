#!/bin/bash

BACKUP_DIR="/home/iftm/backup"
LOG_DIR="/home/iftm/log"
LOG_FILE="$LOG_DIR/log.txt"
SOURCE_DIR="/home/iftm/ADS"
SOURCE_FILE="$SOURCE_DIR/image.jpg"

for DIR in "$BACKUP_DIR" "$LOG_DIR" "$SOURCE_DIR"; do
    if [ ! -d "$DIR" ]; then
        mkdir -p "$DIR"
    fi
done

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Imagem de exemplo criada em $(date)." > "$SOURCE_FILE"
fi

TIMESTAMP=$(date +%Y_%m_%d_%H_%M)
cp "$SOURCE_FILE" "$BACKUP_DIR/image_$TIMESTAMP.jpg"

if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

echo "Backup realizado na data de $(date +'%Y/%m/%d às %H hora %M minutos e %S segundos')." >> "$LOG_FILE"

echo "Backup finalizado com sucesso!"

