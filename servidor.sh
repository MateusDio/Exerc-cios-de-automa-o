#!/bin/bash

LOG="/var/log/monitor_servidor.log"

DATA=$(date "+%Y-%m-%d %H:%M:%S")

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)

RAM=$(free -m | awk '
NR==2 {
printf("%.0f", $3*100/$2)
}')

DISCO=$(df -h / | awk '
NR==2 {
gsub("%","")
print $5
}')

STATUS="[OK]"

if [ "$CPU" -gt 80 ] || [ "$RAM" -gt 85 ] || [ "$DISCO" -gt 90 ]
then
    STATUS="[ALERTA]"
fi

PROCESSOS="sshd nginx"

PROC_STATUS=""

for PROC in $PROCESSOS
do
    if pgrep "$PROC" >/dev/null
    then
        PROC_STATUS="$PROC:OK "
    else
        PROC_STATUS="$PROC:FALHA "
        STATUS="[ALERTA]"
    fi
done

echo "$DATA $STATUS CPU=${CPU}% RAM=${RAM}% DISCO=${DISCO}% $PROC_STATUS" >> "$LOG"
