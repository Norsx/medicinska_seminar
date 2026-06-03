#!/usr/bin/env bash
# Bootstrap a new LiteRealm project.
# Usage:
#   ./.ai/scripts/bootstrap.sh --name "Autonomni_Vilicari"
#   ./.ai/scripts/bootstrap.sh --name "Seminar_MEV" --rag cloud
#   ./.ai/scripts/bootstrap.sh --auto   (reads name from project.yaml)

set -e

NAME=""
RAG="none"
BRAIN="global"
AUTO=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --name)  NAME="$2"; shift 2 ;;
        --rag)   RAG="$2"; shift 2 ;;
        --brain) BRAIN="$2"; shift 2 ;;
        --auto)  AUTO=true; shift ;;
        *)       echo "Unknown option: $1"; exit 1 ;;
    esac
done

root="$(cd "$(dirname "$0")/../.." && pwd)"
marker="$root/.ai/.bootstrapped"

# --- Auto mode: read name from project.yaml ---
if [[ "$AUTO" == true && -z "$NAME" ]]; then
    if [[ -f "$root/.ai/config/project.yaml" ]]; then
        existing_name=$(grep '^name:' "$root/.ai/config/project.yaml" | sed 's/name: *"//' | sed 's/"//')
        if [[ -n "$existing_name" && "$existing_name" != "TBD" ]]; then
            NAME="$existing_name"
        fi
    fi
    if [[ -z "$NAME" ]]; then
        echo ""
        echo "Project name not set yet. Run bootstrap manually:"
        echo "  ./.ai/scripts/bootstrap.sh --name \"Your_Project_Name\""
        echo ""
        echo "Continuing with directory setup only..."
    fi
fi

if [[ "$AUTO" != true && -z "$NAME" ]]; then
    echo "Error: --name is required."
    echo "Usage: ./.ai/scripts/bootstrap.sh --name \"Project_Name\" [--rag none|cloud|local]"
    exit 1
fi

# --- Idempotency check ---
if [[ -f "$marker" ]]; then
    echo ""
    echo "Project already bootstrapped ($(cat "$marker"))."
    echo "Re-running will update config only."
    echo ""
fi

echo ""
echo "=== LiteRealm Bootstrap ==="
echo "Project: ${NAME:-[not set]}"
echo "RAG:     $RAG"
echo "Brain:   $BRAIN"
echo ""

# --- 1. Set project name in config files ---
echo "[1/6] Setting project name..."
if [[ -n "$NAME" ]]; then
    state_file="$root/STATE.md"
    yaml_file="$root/.ai/config/project.yaml"

    if [[ -f "$state_file" ]] && grep -q "_TBD_" "$state_file"; then
        sed -i.bak "s/_TBD_/$NAME/g" "$state_file" && rm -f "$state_file.bak"
    fi
    if [[ -f "$yaml_file" ]] && grep -q '"TBD"' "$yaml_file"; then
        sed -i.bak "s/\"TBD\"/\"$NAME\"/g" "$yaml_file" && rm -f "$yaml_file.bak"
    fi

    # Update RAG mode in project.yaml
    if [[ -f "$yaml_file" ]]; then
        sed -i.bak "s/rag_mode: \"none\"/rag_mode: \"$RAG\"/" "$yaml_file" && rm -f "$yaml_file.bak"
    fi

    echo "  Name '$NAME' written to config files."
else
    echo "  Skipped (no name provided)."
fi

# --- 2. Create directory structure ---
echo "[2/6] Creating directories..."
mkdir -p "$root"/{docs,src,dist,data/raw,data/processed,data/sources}
echo "  Directories created."

# --- 3. Setup .env ---
echo "[3/6] Configuring .env..."
env_file="$root/.env"
env_example="$root/.env.example"

if [[ ! -f "$env_file" ]] && [[ -f "$env_example" ]]; then
    cp "$env_example" "$env_file"
    echo "  .env created from .env.example."
else
    echo "  .env already exists, skipping."
fi

# --- 4. AgentBrain setup ---
echo "[4/6] Checking AgentBrain..."
brain_path="${AGENTBRAIN_PATH:-$HOME/.agentbrain}"

if [[ "$BRAIN" == "global" ]]; then
    if [[ ! -d "$brain_path" ]]; then
        echo "  AgentBrain not found at $brain_path. Cloning..."
        repo_url="https://github.com/KxHartl/AgentBrain.git"
        if git clone "$repo_url" "$brain_path" 2>/dev/null; then
            echo "  AgentBrain cloned successfully."
        else
            echo "  WARNING: Failed to clone AgentBrain (no internet?)."
            echo "  Copying offline fallback template..."
            fallback="$root/.ai/fallback"
            if [[ -d "$fallback" ]]; then
                cp -n "$fallback/minimal.tex" "$root/docs/" 2>/dev/null || true
                cp -n "$fallback/references.bib" "$root/docs/" 2>/dev/null || true
                echo "  Fallback template copied to docs/. RAG will not be available."
            fi
        fi
    else
        echo "  AgentBrain found: $brain_path"
        # Check version contract
        manifest="$brain_path/manifest.yaml"
        if [[ -f "$manifest" ]]; then
            brain_version=$(grep '^version:' "$manifest" | sed 's/version: *"//' | sed 's/"//')
            echo "  AgentBrain version: $brain_version"

            # Stamp version into project.yaml
            yaml_file="$root/.ai/config/project.yaml"
            if [[ -f "$yaml_file" ]] && ! grep -q "agentbrain_version" "$yaml_file"; then
                echo "" >> "$yaml_file"
                echo "# AgentBrain version used during bootstrap" >> "$yaml_file"
                echo "agentbrain_version: \"$brain_version\"" >> "$yaml_file"
                brain_commit=$(cd "$brain_path" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
                echo "agentbrain_commit: \"$brain_commit\"" >> "$yaml_file"
            fi
        else
            echo "  WARNING: AgentBrain manifest.yaml not found. Consider updating AgentBrain."
        fi
    fi
fi

# --- 5. Python environment ---
echo "[5/6] Python environment..."

# Prefer uv, fall back to pip
if command -v uv &>/dev/null; then
    echo "  Using uv (fast mode)."
    venv_path="$root/.venv"
    if [[ ! -d "$venv_path" ]]; then
        uv venv "$venv_path"
    fi
    uv pip install --python "$venv_path/bin/python" -q python-dotenv

    if [[ "$RAG" != "none" && "$BRAIN" == "global" ]]; then
        echo "  Installing RAG dependencies..."
        uv pip install --python "$venv_path/bin/python" -q docling lancedb sentence-transformers pypdf
    fi
    echo "  Python OK (uv)."
else
    # Fallback to traditional pip/venv
    python_cmd=""
    for cmd in python3 python; do
        if $cmd --version 2>&1 | grep -q "Python 3\."; then
            python_cmd="$cmd"
            break
        fi
    done

    if [[ -n "$python_cmd" ]]; then
        venv_path="$root/.venv"
        if [[ ! -d "$venv_path" ]]; then
            $python_cmd -m venv "$venv_path"
        fi

        pip_cmd="$venv_path/bin/pip"
        $pip_cmd install -q python-dotenv 2>/dev/null

        if [[ "$RAG" != "none" && "$BRAIN" == "global" ]]; then
            echo "  Installing RAG dependencies..."
            $pip_cmd install -q docling lancedb sentence-transformers pypdf 2>/dev/null
        fi
        echo "  Python OK ($python_cmd)."
    else
        echo "  Python not found — skipping venv setup."
    fi
fi

# --- 6. Check LaTeX (Tectonic) ---
echo "[6/6] Checking LaTeX compiler..."
if command -v tectonic &>/dev/null; then
    echo "  tectonic found."
elif command -v latexmk &>/dev/null; then
    echo "  latexmk found (legacy). Consider installing Tectonic for faster builds."
else
    echo "  No LaTeX compiler found."
    echo "  Install Tectonic: curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh"
    echo "  Or install TeX Live / MiKTeX for latexmk."
fi

# --- Done ---
echo "$(date -Iseconds) | brain=${brain_version:-unknown} | rag=$RAG" > "$marker"

echo ""
echo "=== Bootstrap complete ==="
echo ""
echo "Next steps:"
echo "  1. Fill in STATE.md with your assignment details"
echo "  2. Copy a LaTeX template from ~/.agentbrain/templates/ into docs/"
echo "  3. Start your AI agent and tell it what to write"
if [[ "$RAG" != "none" ]]; then
    echo "  4. Place PDF sources in data/sources/ for RAG citation"
fi
echo ""
