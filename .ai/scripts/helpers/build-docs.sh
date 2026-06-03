#!/usr/bin/env bash
# Build Documentation Script
# Usage: ./.ai/scripts/helpers/build-docs.sh [--clean] [--engine latexmk]

clean=false
engine="auto"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clean)  clean=true; shift ;;
    --engine) engine="$2"; shift 2 ;;
    *)        echo "Unknown option: $1"; exit 1 ;;
  esac
done

root_dir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root_dir"

echo "--- Building Documentation ---"

dist_dir="${root_dir}/dist"
mkdir -p "$dist_dir"

# Detect engine
if [[ "$engine" == "auto" ]]; then
  if command -v tectonic &>/dev/null; then
    engine="tectonic"
  elif command -v latexmk &>/dev/null; then
    engine="latexmk"
  else
    echo "No LaTeX compiler found. Install Tectonic or TeX Live."
    exit 1
  fi
fi

echo "Engine: $engine"

# Find .tex files
tex_files=$(find docs -maxdepth 2 -name "*.tex" 2>/dev/null)

if [[ -z "$tex_files" ]]; then
  echo "No .tex files found in docs/."
  exit 0
fi

echo "$tex_files" | while read -r file; do
  echo "Building $(basename "$file")..."
  out_dir="$(dirname "$file")/build"
  mkdir -p "$out_dir"

  if [[ "$engine" == "tectonic" ]]; then
    tectonic -X compile "$file" --outdir "$out_dir"
  else
    latexmk -pdf -interaction=nonstopmode -shell-escape "-outdir=$out_dir" "$file"
  fi

  if [[ $? -eq 0 ]]; then
    pdf_name="$(basename "$file" .tex).pdf"
    if [[ -f "${out_dir}/${pdf_name}" ]]; then
      cp "${out_dir}/${pdf_name}" "${dist_dir}/"
      echo "Done: $pdf_name -> dist/"
    fi
  else
    echo "FAILED: $(basename "$file")"
  fi
done

if [[ "$clean" == true ]]; then
  echo "Cleaning build directories..."
  find docs -type d -name "build" -exec rm -rf {} + 2>/dev/null
fi

echo "--- Build Finished ---"
