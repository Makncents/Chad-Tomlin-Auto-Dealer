# Fixing "No Space Left on Device" Error During pip Install

Your installation failed because your disk ran out of space while downloading PyTorch (~915 MB). Here's how to fix it.

## 1. Check Current Disk Usage

```bash
# Check overall disk space
df -h

# Check which directories are using the most space
du -sh ~/* 2>/dev/null | sort -hr | head -20

# Check your home directory usage
du -sh ~
```

## 2. Clear pip Cache (Quick Win)

pip caches downloaded packages, which can consume significant space:

```bash
# Check pip cache size
pip cache info

# Clear the pip cache
pip cache purge
```

## 3. Clean Up Temporary Files

```bash
# Clear system temp files (Linux)
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Clear apt cache (Debian/Ubuntu)
sudo apt-get clean
sudo apt-get autoremove -y

# Clear old journal logs (can be several GB)
sudo journalctl --vacuum-time=7d
```

## 4. Remove Unused Virtual Environments

If you have old virtual environments, they can take up GB of space:

```bash
# List virtual environments in your home directory
find ~ -type d -name "lib" -path "*/python*" 2>/dev/null

# Remove an old virtual environment (example)
# rm -rf ~/old_project/venv
```

## 5. Install Packages in Smaller Batches

Instead of installing everything at once, install in stages:

```bash
# First, activate your virtual environment
source ai_wealth/bin/activate

# Install lightweight packages first
pip install python-dotenv requests beautifulsoup4 pandas

# Install OpenAI (relatively small)
pip install openai

# Install vector database clients
pip install pinecone-client pymilvus

# Install PyTorch LAST (largest package ~915MB + dependencies)
# Consider using CPU-only version if you don't need GPU support:
pip install torch --index-url https://download.pytorch.org/whl/cpu

# Then install packages that depend on torch
pip install sentence-transformers transformers
```

## 6. Use CPU-Only PyTorch (Saves ~1-2GB)

The default PyTorch includes CUDA support which you may not need:

```bash
# CPU-only PyTorch (much smaller)
pip install torch --index-url https://download.pytorch.org/whl/cpu

# Or for a specific version
pip install torch==2.10.0+cpu --index-url https://download.pytorch.org/whl/cpu
```

## 7. Alternative: Use Lighter ML Libraries

If disk space is very limited, consider these alternatives:

```bash
# Instead of full transformers, use just what you need
pip install transformers[torch] --no-deps
pip install tokenizers accelerate safetensors

# For embeddings without PyTorch overhead
pip install fastembed  # Uses ONNX, much lighter
```

## 8. Check What's Using Your Space

```bash
# Find large files in your home directory
find ~ -type f -size +100M 2>/dev/null -exec ls -lh {} \;

# Find large directories
du -h ~ 2>/dev/null | grep -E "^[0-9.]+G"
```

## 9. Move pip Cache to Different Location

If you have another drive with more space:

```bash
# Set pip cache to a different location
export PIP_CACHE_DIR=/path/to/larger/drive/pip-cache
pip install <packages>
```

## Recommended Installation Order

After freeing up space, install in this order:

```bash
# Activate environment
source ai_wealth/bin/activate

# 1. Clear cache first
pip cache purge

# 2. Install in stages
pip install python-dotenv requests beautifulsoup4 pandas certifi urllib3

pip install openai pinecone-client

pip install grpcio protobuf pymilvus

# 3. Install PyTorch (CPU-only to save space)
pip install torch --index-url https://download.pytorch.org/whl/cpu

# 4. Install ML packages
pip install sentence-transformers transformers huggingface-hub
```

## Minimum Disk Space Requirements

- Basic packages (dotenv, requests, pandas, etc.): ~500 MB
- OpenAI + Pinecone: ~200 MB
- PyMilvus: ~300 MB
- PyTorch (CPU-only): ~800 MB
- PyTorch (with CUDA): ~2-3 GB
- Transformers + Sentence-Transformers: ~500 MB

**Total minimum (CPU-only):** ~2.5 GB free space recommended
**Total with GPU support:** ~4-5 GB free space recommended
