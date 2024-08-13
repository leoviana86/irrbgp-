#!/bin/bash

# Arquivos
ARQUIVO_01="arquivo-01"
ARQUIVO_02="arquivo-02"
ARQUIVO_03="arquivo-03"

# Limpar o arquivo temporário
> "$ARQUIVO_03"

# Ordenar os arquivos antes de usar comm
sort "$ARQUIVO_01" > "${ARQUIVO_01}.sorted"
sort "$ARQUIVO_02" > "${ARQUIVO_02}.sorted"

# Arquivo temporário para alterações positivas e negativas
POSITIVE_CHANGES="${ARQUIVO_03}.positive"
NEGATIVE_CHANGES="${ARQUIVO_03}.negative"

# Limpar arquivos temporários
> "$POSITIVE_CHANGES"
> "$NEGATIVE_CHANGES"

# Encontrar alterações negativas (em ARQUIVO_01 mas não em ARQUIVO_02)
comm -23 "${ARQUIVO_01}.sorted" "${ARQUIVO_02}.sorted" | sed 's/^/delete /' > "$NEGATIVE_CHANGES"

# Encontrar alterações positivas (em ARQUIVO_02 mas não em ARQUIVO_01)
comm -13 "${ARQUIVO_01}.sorted" "${ARQUIVO_02}.sorted" | sed 's/^/set /' > "$POSITIVE_CHANGES"

# Remover qualquer "set" adicional das linhas no POSITIVE_CHANGES
sed -i 's/^set set /set /' "$POSITIVE_CHANGES"
# Remover qualquer "delete" adicional das linhas no NEGATIVE_CHANGES
sed -i 's/^delete delete /delete /' "$NEGATIVE_CHANGES"

# Combinar alterações positivas e negativas
cat "$NEGATIVE_CHANGES" "$POSITIVE_CHANGES" > "$ARQUIVO_03"

# Verificar se há alterações no arquivo-03 antes de adicionar "configure" e "commit"
if [ -s "$ARQUIVO_03" ] && [ "$(grep -vE '^(configure;|commit;)$' "$ARQUIVO_03" | wc -l)" -gt 0 ]; then
    # Adicionar "configure;" no início e "commit;" no final do arquivo-03
    { echo "configure;"; cat "$ARQUIVO_03"; echo "commit;"; } > "${ARQUIVO_03}.updated"

    # Substituir o arquivo-03 original pelo atualizado
    mv "${ARQUIVO_03}.updated" "$ARQUIVO_03"

    # Configurar detalhes do email
    EMAIL_SUBJECT="Diferenças entre arquivo-02 e arquivo-01"
    EMAIL_BODY="As diferenças encontradas entre os arquivos foram:"
    EMAIL_TO="enzo@hilux-net.com.br"  # Substitua pelo destinatário real

    # Enviar o email com o conteúdo do arquivo-03 usando mutt
    { echo "$EMAIL_BODY"; cat "$ARQUIVO_03"; } | mutt -s "$EMAIL_SUBJECT" "$EMAIL_TO"
else
    # Adicionar "exit;" no arquivo-03 se não houver alterações
    echo "exit;" > "$ARQUIVO_03"
fi

# Replicar o conteúdo do arquivo-02 para o arquivo-01
cp "$ARQUIVO_02" "$ARQUIVO_01"

# Limpar arquivos temporários
rm "${ARQUIVO_01}.sorted" "${ARQUIVO_02}.sorted" "$POSITIVE_CHANGES" "$NEGATIVE_CHANGES"
