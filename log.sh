#!/bin/bash

ONTEM=$(date -d "yesterday" +%F)

LOG="/var/log/webserver/$ONTEM.log"
RELATORIO="/relatorios/log_$ONTEM.txt"

mkdir -p /relatorios

echo "RELATÓRIO DE LOGS" > "$RELATORIO"
echo "Data: $(date)" >> "$RELATORIO"
echo "==========================" >> "$RELATORIO"

TOTAL=$(wc -l < "$LOG")

HTTP200=$(grep " | 200 | " "$LOG" | wc -l)
HTTP404=$(grep " | 404 | " "$LOG" | wc -l)
HTTP500=$(grep " | 500 | " "$LOG" | wc -l)

echo "Total de requisições: $TOTAL" >> "$RELATORIO"
echo "200: $HTTP200" >> "$RELATORIO"
echo "404: $HTTP404" >> "$RELATORIO"
echo "500: $HTTP500" >> "$RELATORIO"

echo "" >> "$RELATORIO"
echo "TOP 5 ERROS 404" >> "$RELATORIO"

grep " | 404 | " "$LOG" |
awk -F'|' '{print $3}' |
sort |
uniq -c |
sort -nr |
head -5 >> "$RELATORIO"

echo "" >> "$RELATORIO"
echo "REQUISIÇÕES ACIMA DE 2 SEGUNDOS" >> "$RELATORIO"

awk -F'|' '
{
tempo=$4
gsub("s","",tempo)

if(tempo>2)
print $0
}
' "$LOG" >> "$RELATORIO"

if [ "$HTTP500" -gt 10 ]
then
    echo "ALERTA: Mais de 10 erros 500 encontrados!"
fi
