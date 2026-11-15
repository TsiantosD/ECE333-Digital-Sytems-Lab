#!/usr/bin/env bash
# Packs the sources of parts A-D (without the Vivado projects) and report.pdf.
# Usage: ./zip.sh [output.zip]   (default: lab1.zip)
set -euo pipefail

cd "$(dirname "$0")"

out="${1:-lab1.zip}"

for f in part-A part-B part-C part-D report.pdf; do
    [ -e "$f" ] || { echo "missing: $f" >&2; exit 1; }
done

rm -f "$out"
zip -r "$out" part-A part-B part-C part-D report.pdf \
    -x 'part-*/project/*' \
       '*/.Xil/*' '*/xsim.dir/*' \
       '*.vcd' '*.wdb' '*.jou' '*.log' '*.pb' '*.str'

echo
unzip -l "$out"
