#!/bin/bash
# test_upload_gcs.sh
# Teste de upload e download via presigned URL GCS

# ---------------------------
# CONFIGURAÇÃO
# ---------------------------
# Caminho do arquivo que você quer enviar
FILE_PATH="./teste.jpg"
# Content-Type do arquivo (deve bater com o que você usou para gerar a presigned URL)
CONTENT_TYPE="image/jpeg"
# Presigned URL gerada pelo seu backend (PUT)
PRESIGNED_URL="COLE_AQUI_SUA_PRESIGNED_URL"
# URL para download (GET) - opcional
DOWNLOAD_URL="COLE_AQUI_SUA_PRESIGNED_GET_URL"
# Nome do arquivo que será salvo após download
OUTPUT_FILE="./baixado.jpg"

# ---------------------------
# FUNÇÃO DE UPLOAD
# ---------------------------
upload_file() {
    echo "🔼 Enviando arquivo para GCS..."
    curl -X PUT \
        -H "Content-Type: $CONTENT_TYPE" \
        --data-binary @"$FILE_PATH" \
        "$PRESIGNED_URL" \
        -w "\nHTTP STATUS: %{http_code}\n"

    if [ $? -eq 0 ]; then
        echo "✅ Upload concluído!"
    else
        echo "❌ Erro no upload"
    fi
}

# ---------------------------
# FUNÇÃO DE DOWNLOAD
# ---------------------------
download_file() {
    if [ -z "$DOWNLOAD_URL" ]; then
        echo "⚠️  Download URL não fornecida. Pulei esta etapa."
        return
    fi

    echo "🔽 Baixando arquivo do GCS..."
    curl -o "$OUTPUT_FILE" "$DOWNLOAD_URL" -w "\nHTTP STATUS: %{http_code}\n"

    if [ $? -eq 0 ]; then
        echo "✅ Download concluído! Arquivo salvo em $OUTPUT_FILE"
    else
        echo "❌ Erro no download"
    fi
}

# ---------------------------
# EXECUÇÃO
# ---------------------------
upload_file
download_file

