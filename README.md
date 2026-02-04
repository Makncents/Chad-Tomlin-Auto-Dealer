# Chad-Tomlin-Auto-Dealer

## Python environment setup

Create and activate a virtual environment:

```bash
python -m venv ai_wealth
source ai_wealth/bin/activate  # Linux/macOS
```

Windows activation (use the one that matches your shell):

```powershell
# PowerShell
.\ai_wealth\Scripts\Activate.ps1

# cmd.exe
ai_wealth\Scripts\activate.bat
```

Note: `ai_wealth\Scripts\activate` is a Windows path and will not work in bash.

## Install dependencies

Full install (includes local transformer models):

```bash
python -m pip install --upgrade pip
pip install --no-cache-dir -r requirements.txt
```

Low disk space install tips:

```bash
export PIP_NO_CACHE_DIR=1
export TMPDIR="$(pwd)/.tmp"
mkdir -p "$TMPDIR"
pip install -r requirements.txt
```

If you do not need local embedding/transformer models, use the lighter set:

```bash
pip install --no-cache-dir -r requirements-core.txt
```

`torch` is large (around 1 GB). Make sure you have enough free disk space,
or install the lighter set if you only need API-based embeddings.