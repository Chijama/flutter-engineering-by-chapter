#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
echo "Usage: scripts/run_with_env.sh <env-file> [-- extra flutter args]"
exit 1
fi

ENV_FILE="$1"
shift || true

DEFINES=()
ext="${ENV_FILE##*.}"

if [ "$ext" = "env" ]; then
while IFS='=' read -r key val; do
[[ -z "$key" || "$key" =~ ^# ]] && continue
DEFINES+=(--dart-define="${key}=${val}")
done < "$ENV_FILE"
elif [ "$ext" = "json" ]; then
if ! command -v jq >/dev/null 2>&1; then
echo "jq is required for JSON mode. Install jq and retry."
exit 2
fi
for k in $(jq -r 'keys[]' "$ENV_FILE"); do
v=$(jq -r --arg k "$k" '.[$k]' "$ENV_FILE")
DEFINES+=(--dart-define="${k}=${v}")
done
else
echo "Unsupported file extension: .$ext (use .env or .json)"
exit 3
fi

flutter run -t lib/dart_define_version/main.dart "${DEFINES[@]}" "$@"
