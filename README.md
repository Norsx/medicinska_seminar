# medicinska_seminar
Medicinska robotika - Upravljački pristupi za autonomno robotsko ultrazvučno snimanje


# LiteRealm

**LiteRealm** is a lightweight, OS-independent boilerplate for creating academic papers, assignments, and software projects with AI agents (Claude, Gemini, Copilot).

Instead of installing heavy tools locally, LiteRealm offers **Dev Containers** (optional) to run everything in an isolated Docker environment. If you prefer not to use Docker, you only need Python and a LaTeX compiler.

All generic scripts, templates, and agent "skills" are stored in a separate global repository: **`AgentBrain`** (`~/.agentbrain`). LiteRealm is intentionally lightweight and focused on your specific project.

---

## Quick Start

### 1. Prerequisites

Choose one:
- **Local**: Python 3.10+ and [Tectonic](https://tectonic-typesetting.github.io/en-US/install.html) (recommended) or TeX Live / MiKTeX.
- **Docker**: Docker Desktop and the VS Code *Dev Containers* extension.

Optional but recommended: [uv](https://docs.astral.sh/uv/) for fast Python package management.

### 2. Create a New Project

This repository is a GitHub Template:
1. Click the green **"Use this template"** → **"Create a new repository"**.
2. Clone it:
   ```bash
   git clone <YOUR_NEW_REPO_URL>
   cd <YOUR_FOLDER_NAME>
   ```

*(Docker users: open VS Code and click "Reopen in Container".)*

### 3. Initialize

Open a terminal and run the setup script:

**Windows (PowerShell):**
```powershell
.\.ai\scripts\bootstrap.ps1 -Name "My_Paper_Name" -Rag cloud
```
**Linux / macOS (Bash):**
```bash
./.ai/scripts/bootstrap.sh --name "My_Paper_Name" --rag cloud
```

The script will:
- Write the project name into `STATE.md` and `project.yaml`.
- Create all directories (`data/raw`, `data/processed`, `docs`, `src`).
- Configure the `.env` file.
- Create a Python virtual environment and install dependencies.
- Clone `AgentBrain` to `~/.agentbrain` if it doesn't exist.
- Check the AgentBrain version contract.

### 4. Copy a Template

Copy your desired LaTeX template from `~/.agentbrain/templates/` (e.g., `fsb-seminar` or `fsb-paper`) into `docs/`. Then start your AI agent.

---

## Directory Structure

| Directory | Purpose |
|---|---|
| `docs/` | Your written work: `.tex` files, images, and generated PDFs. |
| `src/` | Source code, scripts, and algorithms. |
| `dist/` | Final versions for submission (final PDFs, zip files). |
| `data/raw/` | Raw data (reports, tables, API dumps). **Read-only.** |
| `data/processed/` | Processed data in subfolders: `source_ddmmyyyy_hhmmss`. |
| `data/sources/` | PDF literature for the RAG system. |
| `.ai/` | Internal rules (`AGENTS.md`), scripts, and config. |
| `~/.agentbrain/` | (Separate repo) Global templates, skills, agents, and RAG scripts. |

---

## Working with AI Agents

LiteRealm defines five specialized agents (see `~/.agentbrain/agents/`):

| Agent | Role |
|---|---|
| `data_fetcher` | Finds and downloads literature, logs sources |
| `writer` | Writes academic content in LaTeX, manages citations |
| `qa_reviewer` | Reviews written content, produces critique in `REVIEW.md` |
| `latex_surgeon` | Debugs and fixes LaTeX compilation errors |
| `rag_indexer` | Maintains the RAG vector database |

**Pipeline**: fetch → write → review → fix → index

### Rules for agents
1. **Source Tracking**: Every download must be logged in `data/SOURCES_LOG.md`.
2. **Visible Git Commits**: All AI commits must be incremental and tagged with `🤖 [AI]`.
3. **Isolated Work**: Risky tasks must use `git worktree` to protect the main codebase.

---

## RAG (Chat with your literature)

PDFs are parsed with **Docling** (IBM's ML-based parser — understands tables, multi-column layouts, figures, and technical drawings) and stored in a **LanceDB** vector store. No hallucinated citations.

1. Place literature PDFs in `data/sources/`.
2. Ingest:
   ```bash
   python ~/.agentbrain/scripts/rag/ingest.py
   python ~/.agentbrain/scripts/rag/ingest.py --ocr    # for scanned PDFs
   ```
3. Query:
   ```bash
   python ~/.agentbrain/scripts/rag/query.py "Your question" --scope both
   ```
4. Auto-generate BibTeX from DOI:
   ```bash
   python ~/.agentbrain/scripts/add_citation.py --doi "10.1109/TRO.2024.1234567"
   ```

---

## Compiling PDFs

```powershell
.\.ai\scripts\helpers\build-docs.ps1       # PowerShell
./.ai/scripts/helpers/build-docs.sh        # Bash
```

Supports **Tectonic** (default, fast, auto-downloads packages) and **latexmk** (legacy). Override with `--engine latexmk`.

The GitHub Actions workflow automatically compiles on every push to `main` and attaches the PDF as an artifact.

---

## Tooling

| Tool | Purpose | Install |
|---|---|---|
| [Tectonic](https://tectonic-typesetting.github.io/) | LaTeX compiler (~50MB, auto-downloads packages) | `curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net \| sh` |
| [uv](https://docs.astral.sh/uv/) | Fast Python package manager (10-100x faster than pip) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| [Docling](https://docling-project.github.io/docling/) | ML-based PDF parser (tables, layout, figures, OCR) | `pip install docling` |
| [LanceDB](https://lancedb.github.io/lancedb/) | File-based vector store for RAG | `pip install lancedb` |
