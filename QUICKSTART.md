# Quick Start - Fix "No Space Left on Device" Error

## Your Error

```
OSError: [Errno 28] No space left on device
```

## Immediate Solution (3 Steps)

### Step 1: Clean Up Disk Space

```bash
# Clear pip cache immediately
pip cache purge

# Remove Python bytecode
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null

# Or use our cleanup script
bash cleanup_disk.sh
```

### Step 2: Install Packages with No Cache

```bash
# Make sure you're in your virtual environment
source ai_wealth/bin/activate  # Linux/Mac
# or: ai_wealth\Scripts\activate  # Windows

# Install with --no-cache-dir flag
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

### Step 3: Verify Installation

```bash
python verify_installation.py
```

## Why This Works

1. **`pip cache purge`** - Removes cached downloads (can be GBs of space)
2. **`--no-cache-dir`** - Prevents pip from saving packages to cache
3. **CPU-only PyTorch** - Uses ~200MB instead of ~900MB for GPU version

## If You Still Have Issues

### Check Available Space

```bash
df -h
```

You need at least 2-3 GB free space.

### Run Full Cleanup

```bash
bash cleanup_disk.sh
```

### Use Our Installation Script

```bash
bash install_packages.sh
```

This script:
- Checks disk space before installing
- Installs packages in optimal order
- Cleans up after each step
- Verifies installation

## Alternative: Use Cloud Platform

If you're working with large ML models, consider using:

- **Google Colab** - Free Jupyter notebooks with GPU
  - Go to: https://colab.research.google.com/
  - No installation needed, everything pre-configured

- **Kaggle Notebooks** - Free environment
  - Go to: https://www.kaggle.com/code
  - Pre-installed ML packages

## Need More Help?

See detailed documentation:
- [README.md](README.md) - Complete guide
- [DISK_SPACE_SOLUTIONS.md](DISK_SPACE_SOLUTIONS.md) - Advanced troubleshooting

## Quick Reference

```bash
# Check disk space
df -h

# Clear pip cache
pip cache purge

# Install without cache
pip install --no-cache-dir package_name

# CPU-only PyTorch (smaller)
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu

# Check installed packages
pip list

# Run our scripts
bash check_disk_space.sh    # Analyze disk usage
bash cleanup_disk.sh         # Clean up space
bash install_packages.sh     # Install packages safely
python verify_installation.py # Verify installation
```
