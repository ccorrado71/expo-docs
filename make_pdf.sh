#!/bin/bash
# Generate the EXPO PDF manual from the Markdown sources.
# Requires: pandoc, xelatex (texlive-xetex)
#
# Usage: bash make_pdf.sh [output.pdf]

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-${SCRIPT_DIR}/expo_manual.pdf}"

# Keep this list in the same order as the 'nav' section of mkdocs.yml
PAGES=(
  index.md
)

pandoc \
  "${PAGES[@]/#/${SCRIPT_DIR}/docs/}" \
  --resource-path="${SCRIPT_DIR}/docs" \
  -o "${OUT}" \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=2 \
  -V geometry:margin=2.5cm \
  -V fontsize=11pt \
  -V lang=en \
  -V mainfont="DejaVu Serif" \
  -V sansfont="DejaVu Sans" \
  -V monofont="DejaVu Sans Mono" \
  --metadata title="EXPO Manual"

echo "PDF generated: ${OUT}"
