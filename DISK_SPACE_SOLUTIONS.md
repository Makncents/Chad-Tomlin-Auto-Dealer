# Disk Space Solutions for Python Package Installation

## Problem Overview

When installing large Python packages (like PyTorch, TensorFlow, etc.), you may encounter:
```
OSError: [Errno 28] No space left on device
```

This happens because:
1. **Large package downloads**: PyTorch alone can be 900+ MB
2. **Pip cache**: Pip stores downloaded packages in cache
3. **Temporary files**: Build artifacts accumulate during installation
4. **Virtual environment overhead**: Multiple copies of packages across environments

## Quick Fix Solutions

### Solution 1: Clear Pip Cache

```bash
# Check pip cache size
pip cache info

# Clear all pip cache
pip cache purge

# Alternative: Clear specific package cache
pip cache remove torch
```

### Solution 2: Install Without Cache

```bash
# Install packages without caching (saves disk space)
pip install --no-cache-dir python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

### Solution 3: Install Packages Individually

Instead of installing all at once, install in smaller batches:

```bash
# Install lightweight packages first
pip install --no-cache-dir python-dotenv requests beautifulsoup4 pandas

# Install medium packages
pip install --no-cache-dir openai pinecone-client pymilvus

# Install heavy packages separately
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu  # CPU version is smaller
pip install --no-cache-dir sentence-transformers transformers
```

### Solution 4: Use CPU-Only PyTorch (Smaller Size)

If you don't need GPU support, use CPU-only PyTorch:

```bash
# CPU version is significantly smaller (~200MB vs ~900MB)
pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir sentence-transformers transformers
```

## Disk Space Cleanup

### Check Available Space

```bash
# Check disk space
df -h

# Check directory sizes in your home folder
du -sh ~/* 2>/dev/null | sort -h | tail -10

# Check pip cache location and size
pip cache info
```

### Clean Up Temporary Files

```bash
# Clean pip cache
pip cache purge

# Clean Python bytecode files
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null

# Clean temporary files
rm -rf /tmp/*
rm -rf ~/.cache/pip

# Clean old virtual environments (if any)
# Be careful - only delete if you're sure you don't need them
# rm -rf ~/old_venv_name
```

### Clean System Cache (Linux/Mac)

```bash
# Ubuntu/Debian
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove

# Check for large log files
sudo du -sh /var/log/* | sort -h | tail -10

# Optional: Clear old logs (be careful!)
# sudo journalctl --vacuum-time=7d
```

## Prevention Strategies

### 1. Use requirements.txt with Specific Versions

Create a `requirements.txt` file to control exactly what gets installed:

```txt
python-dotenv==1.2.1
openai==2.16.0
pinecone-client==6.0.0
pymilvus==2.6.8
sentence-transformers==5.2.2
transformers==5.0.0
beautifulsoup4==4.14.3
requests==2.32.5
pandas==3.0.0
# Use CPU-only torch if GPU not needed
--index-url https://download.pytorch.org/whl/cpu
torch>=2.0.0
```

Install with:
```bash
pip install --no-cache-dir -r requirements.txt
```

### 2. Use Virtual Environments Wisely

```bash
# Create a new virtual environment
python -m venv ai_wealth

# Activate it (Linux/Mac)
source ai_wealth/bin/activate

# Activate it (Windows)
ai_wealth\Scripts\activate

# When done, deactivate
deactivate
```

### 3. Consider Using Conda

Conda can sometimes manage disk space better:

```bash
# Install miniconda (lighter than Anaconda)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Create environment with packages
conda create -n ai_wealth python=3.11
conda activate ai_wealth

# Install packages (conda manages cache better)
conda install pytorch cpuonly -c pytorch
pip install python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

### 4. Use Docker Containers

For isolated environments with better space management:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install with no cache
RUN pip install --no-cache-dir -r requirements.txt

# Clean up
RUN rm -rf /root/.cache/pip
```

## Troubleshooting Steps

### Step 1: Diagnose the Problem

```bash
# Check current disk usage
df -h

# Find large directories
du -sh ~/* 2>/dev/null | sort -h | tail -20

# Check pip cache
pip cache info
```

### Step 2: Free Up Space

```bash
# Run the cleanup script (see cleanup_disk.sh)
bash cleanup_disk.sh

# Or manually:
pip cache purge
rm -rf ~/.cache/pip
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
```

### Step 3: Retry Installation

```bash
# Try with no cache and CPU-only packages
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

## Package Size Reference

Approximate download sizes:

| Package | Size | Notes |
|---------|------|-------|
| torch (GPU) | ~900 MB | CUDA version |
| torch (CPU) | ~200 MB | CPU-only version |
| transformers | ~10 MB | But downloads models |
| sentence-transformers | ~500 KB | But downloads models |
| pandas | ~11 MB | With dependencies |
| numpy | ~15 MB | Usually included |
| tensorflow | ~500 MB | Another large ML framework |

**Pro Tip**: If you're doing NLP/AI work, consider using cloud platforms (Google Colab, Kaggle, AWS SageMaker) which provide pre-installed environments.

## Advanced: Shared Package Cache

If you have multiple virtual environments, consider using a shared package cache:

```bash
# Install virtualenv with shared site-packages
python -m venv --system-site-packages shared_env

# Or use pipx for tools
pip install pipx
pipx install package_name
```

## Emergency: Out of Space Mid-Installation

If installation fails mid-way:

```bash
# 1. Stop any running installations (Ctrl+C)

# 2. Clean pip cache immediately
pip cache purge

# 3. Clean temporary Python files
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null
rm -rf /tmp/pip-*

# 4. Check what was partially installed
pip list

# 5. Try installing individual packages with --no-cache-dir
pip install --no-cache-dir package_name
```

## Recommended Installation Command

For the packages you need, use this optimized command:

```bash
# Activate your virtual environment first
source ai_wealth/bin/activate  # Linux/Mac
# or ai_wealth\Scripts\activate on Windows

# Install with no cache and CPU-only PyTorch
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

## Additional Resources

- [Pip User Guide - Caching](https://pip.pypa.io/en/stable/topics/caching/)
- [Managing Disk Space in Python Projects](https://realpython.com/python-virtual-environments/)
- [PyTorch Installation Options](https://pytorch.org/get-started/locally/)

## Need More Help?

If you continue to have disk space issues:

1. **Check your system**: `df -h` to see available space
2. **Run cleanup script**: Use the provided `cleanup_disk.sh`
3. **Consider cloud platforms**: Google Colab, Kaggle notebooks (free with GPUs)
4. **Use lighter alternatives**: Consider lightweight models and CPU-only versions
