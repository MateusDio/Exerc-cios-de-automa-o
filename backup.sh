#!/bin/bash


ORIGEM="/clinica/dados"
DESTINO="/mnt/hd_externo/backups"
LOG="/var/log/backup_clinica.log"


DATA=$(date +%F)


if [ ! -d "$DESTINO" ]; then
    mkdir -p "$DESTINO"
fi


ARQUIVO="$DESTINO/backup_$DATA.tar.gz"


if tar -czf "$ARQUIVO" "$ORIGEM"; then
    STATUS="SUCESSO"
    TAMANHO=$(du -h "$ARQUIVO" | cut -f1)
else
    STATUS="FALHA"
    TAMANHO="0"
fi


find "$DESTINO" -name "*.tar.gz" -mtime +30 -delete


echo "$(date '+%Y-%m-%d %H:%M:%S') | Arquivo: $(basename "$ARQUIVO") | Tamanho: $TAMANHO | Status: $STATUS" >> "$LOG"


echo "===== RESUMO DO BACKUP ====="
echo "Data: $(date)"
echo "Arquivo: $(basename "$ARQUIVO")"
echo "Tamanho: $TAMANHO"
echo "Status: $STATUS"
echo "Destino: $DESTINO"
echo "============================"
