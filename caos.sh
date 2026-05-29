#!/bin/bash

mkdir documentos imagens videos outros

doc=$(ls *.txt *.pdf 2>/dev/null | wc -1)
img=$(ls *.jpg *.jpeg *.png 2>/dev/null | wc -1)
vid=$(ls *.mp4 2>/dev/null | wc -1)

espaco=$(du -ch *.tmp 2>/dev/null | tail -n 1 | awk '{print $1}')

mv *.txt documentos/ 2>/dev/null
mv *.pdf documentos/ 2>/dev/null
mv *.jpg imagens/ 2>/dev/null
mv *.mp4 videos/ 2>/dev/null
mv * outros/ 2>/dev/null

rm *.tmp/ 2>/dev/null

relatorio="relatorio_organizacao.txt"

echo "Relatorio" > "$relatorio"

echo "Data: $(date)" >>  "$relatorio"

echo "Documentos: $doc" >> "$relatorio"

echo  "Imagens: $img" >> "$relatorio"

echo "Videos: $vid" >> "$relatorio"

echo "Espaço liberado: $espaço" >> "$relatorio"
