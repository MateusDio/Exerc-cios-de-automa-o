#!/bin/bash

ARQUIVO="alunos.csv"
RELATORIO="relatorio_cadastro.txt"

TOTAL=0
FALHAS=0

echo "RELATÓRIO DE CADASTRO" > "$RELATORIO"
echo "=====================" >> "$RELATORIO"
echo "" >> "$RELATORIO"

tail -n +2 "$ARQUIVO" | while IFS=',' read -r NOME CPF TURMA EMAIL
do
    USUARIO=$(echo "$NOME" | tr '[:upper:]' '[:lower:]' | tr ' ' '.')

    mkdir -p "/turmas/$TURMA"

    SENHA=$(echo "$CPF" | tr -d '.-')

    if id "$USUARIO" &>/dev/null
    then
        echo "[ERRO] Usuário $USUARIO já existe" >> "$RELATORIO"
        ((FALHAS++))
    else
        useradd -m "$USUARIO"

        echo "$USUARIO:$SENHA" | chpasswd

        usermod -aG "$TURMA" "$USUARIO" 2>/dev/null

        echo "$USUARIO ($TURMA)" >> "$RELATORIO"

        ((TOTAL++))
    fi
done

echo "" >> "$RELATORIO"
echo "Total criados: $TOTAL" >> "$RELATORIO"
echo "Falhas: $FALHAS" >> "$RELATORIO"

