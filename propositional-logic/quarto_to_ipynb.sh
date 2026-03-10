#!/usr/bin/env bash
set -euo pipefail

# Usage: ./qmd_to_ipynb.sh <file.qmd>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file.qmd>"
  exit 1
fi

INPUT="$1"

if [[ ! -f "$INPUT" ]]; then
  echo "Error: file '$INPUT' not found."
  exit 1
fi

if [[ "${INPUT##*.}" != "qmd" ]]; then
  echo "Error: expected a .qmd file, got '$INPUT'."
  exit 1
fi

BASENAME="${INPUT%.qmd}"
NOTEBOOK="${BASENAME}.ipynb"

KERNEL="julia-1.11"

echo "Using kernel: $KERNEL"

echo "Step 1: Converting '$INPUT' to '$NOTEBOOK'..."
quarto render "$INPUT" --to ipynb --output "$NOTEBOOK"

echo "Step 2: Executing '$NOTEBOOK' with nbconvert..."
jupyter nbconvert --to notebook --execute \
  --ExecutePreprocessor.kernel_name="$KERNEL" \
  "$NOTEBOOK" \
  --inplace

echo "Done! Executed notebook saved to '$NOTEBOOK'."
