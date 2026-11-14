#!/bin/bash
# Generate the EXPO PDF manual from the Markdown sources.
# Requires: pandoc, xelatex (texlive-xetex), python3
#
# Usage: bash make_pdf.sh [output.pdf]

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-${SCRIPT_DIR}/expo_manual.pdf}"

# Keep this list in the same order as the 'nav' section of mkdocs.yml
PAGES=(
  index.md
  download.md
  installation.md
  tutorials.md
  input/index.md
  input/commands.md
  input/data.md
  input/structure-files.md
  indexing.md
  space-group.md
  direct-methods/index.md
  direct-methods/extraction.md
  direct-methods/normalization.md
  direct-methods/invariants.md
  direct-methods/phasing.md
  direct-methods/fourier.md
  direct-space/index.md
  direct-space/directives.md
  direct-space/parallel.md
  direct-space/examples.md
  rietveld.md
  tools/index.md
  tools/geometry-optimization.md
  tools/bond-valence.md
  appendix/atomic-volumes.md
  appendix/extinction-symbols.md
)

# MkDocs admonitions (!!! / ???) are not understood by pandoc:
# convert them to block quotes with a bold title.
convert_admonitions() {
  python3 - "$1" <<'EOF'
import re, sys
head = re.compile(r'^(!!!|\?\?\?\+?)\s+(\w+)(?:\s+"([^"]*)")?\s*$')
out, quote = [], False
for line in open(sys.argv[1], encoding="utf-8").read().splitlines():
    m = head.match(line)
    if m:
        out.append("> **" + (m.group(3) or m.group(2).capitalize()) + "**")
        out.append(">")
        quote = True
    elif quote and (line.startswith("    ") or not line.strip()):
        out.append(("> " + line[4:]).rstrip())
    else:
        quote = False
        out.append(line)
# Long DOIs do not fit the line: typeset them as breakable URLs (xurl package)
doi = re.compile(r'\[(doi:[^\]]+)\]\((https://doi\.org/[^)\s]+)\)')
text = "\n".join(out)
text = doi.sub(lambda m: r"\href{%s}{\nolinkurl{%s}}" % (m.group(2).replace("%", r"\%"), m.group(1)), text)
print(text)
EOF
}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT
SOURCES=()
for page in "${PAGES[@]}"; do
  dest="${TMP_DIR}/${page//\//_}"
  convert_admonitions "${SCRIPT_DIR}/docs/${page}" > "${dest}"
  SOURCES+=("${dest}")
done

pandoc \
  "${SOURCES[@]}" \
  --from=markdown-implicit_figures+link_attributes \
  --resource-path="${SCRIPT_DIR}/docs:${SCRIPT_DIR}/docs/direct-methods:${SCRIPT_DIR}/docs/direct-space:${SCRIPT_DIR}/docs/input:${SCRIPT_DIR}/docs/tools:${SCRIPT_DIR}/docs/appendix" \
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
  -V header-includes='\usepackage{xurl}' \
  --metadata title="EXPO Manual"

echo "PDF generated: ${OUT}"
