#!/usr/bin/env bash
set -euo pipefail

INTERVAL_SECONDS="${1:-300}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTO_SCRIPT="$SCRIPT_DIR/git_auto_push.sh"

if [ ! -x "$AUTO_SCRIPT" ]; then
  echo "Erro: $AUTO_SCRIPT não é executável."
  exit 1
fi

echo "Watcher iniciado. Verificando a cada ${INTERVAL_SECONDS}s. Ctrl+C para sair."

while true; do
  cd "$SCRIPT_DIR"
  if ! git status --porcelain | grep -q .; then
    echo "[$(date '+%H:%M:%S')] Nenhuma alteração."
  else
    echo
    echo "[$(date '+%H:%M:%S')] Foram detectadas alterações."
    read -p "Executar git_auto_push.sh agora? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      ./git_auto_push.sh || echo "Commit/push falhou. Verifique acima."
    else
      echo "Ignorando alterações por enquanto."
    fi
  fi
  sleep "$INTERVAL_SECONDS"
done
