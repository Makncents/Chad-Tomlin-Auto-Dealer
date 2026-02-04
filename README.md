# Python Package Installation - Disk Space Management

This repository provides comprehensive solutions for managing disk space when installing large Python packages, particularly for AI/ML development with packages like PyTorch, TensorFlow, and Transformers.

## The Problem

When installing Python packages, especially for machine learning projects, you might encounter:

```
OSError: [Errno 28] No space left on device
```

This typically happens when:
- Installing large packages like PyTorch (~900MB for GPU version)
- Pip cache accumulates downloaded packages
- Multiple virtual environments consume disk space
- Build artifacts and temporary files accumulate

## Quick Start

### 1. Check Your Disk Space

```bash
bash check_disk_space.sh
```

This script will:
- Analyze available disk space
- Show pip cache size
- Identify large directories
- Provide recommendations

### 2. Clean Up (If Needed)

```bash
bash cleanup_disk.sh
```

This script will:
- Clear pip cache
- Remove Python bytecode (`__pycache__`)
- Clean temporary files
- Remove build artifacts

### 3. Install Packages Safely

#### Option A: Use the installation script (recommended)

```bash
# Create and activate virtual environment
python -m venv ai_wealth
source ai_wealth/bin/activate  # Linux/Mac
# or: ai_wealth\Scripts\activate  # Windows

# Run the safe installation script
bash install_packages.sh
```

#### Option B: Use requirements.txt

```bash
pip install --no-cache-dir -r requirements.txt
```

#### Option C: Manual installation with optimizations

```bash
# Install without cache to save space
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

### 4. Verify Installation

```bash
python verify_installation.py
```

## Scripts Provided

### `check_disk_space.sh`
Analyzes your system's disk usage and provides recommendations.

**Usage:**
```bash
bash check_disk_space.sh
```

**Features:**
- Shows overall disk space
- Analyzes pip cache size
- Lists largest directories
- Identifies Python-related disk usage
- Provides actionable recommendations

### `cleanup_disk.sh`
Safely cleans up disk space by removing unnecessary files.

**Usage:**
```bash
bash cleanup_disk.sh
```

**What it cleans:**
- Pip cache (`~/.cache/pip`)
- Python bytecode (`__pycache__`, `*.pyc`)
- Temporary pip files
- Build artifacts (`build/`, `dist/`, `*.egg-info`)
- Test cache (`.pytest_cache`, `.coverage`)

### `install_packages.sh`
Installs Python packages with disk space optimization.

**Usage:**
```bash
bash install_packages.sh
```

**Features:**
- Checks available disk space before installation
- Uses `--no-cache-dir` to prevent cache buildup
- Installs CPU-only PyTorch (smaller size)
- Installs packages in stages
- Cleans up after installation
- Verifies successful installation

### `verify_installation.py`
Checks if all required packages are installed correctly.

**Usage:**
```bash
python verify_installation.py
```

**Features:**
- Verifies all required packages
- Shows package versions
- Checks PyTorch configuration (CPU/GPU)
- Provides diagnostic information

## Package Requirements

The `requirements.txt` file includes:

### Core Utilities
- `python-dotenv` - Environment variable management
- `requests` - HTTP library
- `beautifulsoup4` - Web scraping

### Data Processing
- `pandas` - Data manipulation and analysis

### AI/ML Packages
- `openai` - OpenAI API client
- `pinecone-client` - Vector database client
- `pymilvus` - Milvus vector database client
- `sentence-transformers` - Sentence embeddings
- `transformers` - Hugging Face transformers
- `torch` - PyTorch (CPU version by default)

## Disk Space Optimization Tips

### 1. Always Use `--no-cache-dir`

```bash
pip install --no-cache-dir package_name
```

This prevents pip from caching downloaded packages, saving significant disk space.

### 2. Use CPU-Only PyTorch (If You Don't Need GPU)

```bash
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
```

CPU version: ~200MB vs GPU version: ~900MB

### 3. Install Packages Individually

Instead of installing everything at once:

```bash
# Install in stages
pip install --no-cache-dir python-dotenv requests beautifulsoup4
pip install --no-cache-dir pandas
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir transformers sentence-transformers
```

### 4. Clean Pip Cache Regularly

```bash
pip cache purge
```

### 5. Remove Unused Virtual Environments

```bash
# List virtual environments
find ~ -type d -name "venv" -o -name "env" -o -name ".venv"

# Remove unused ones
rm -rf ~/path/to/old_venv
```

### 6. Use Virtual Environments

Always use virtual environments to keep dependencies isolated:

```bash
python -m venv ai_wealth
source ai_wealth/bin/activate
```

## Troubleshooting

### Issue: "No space left on device" during installation

**Solution:**
1. Stop the installation (Ctrl+C)
2. Run `bash cleanup_disk.sh`
3. Try again with `bash install_packages.sh`

### Issue: Pip cache taking too much space

**Solution:**
```bash
pip cache info  # Check size
pip cache purge  # Clear cache
```

### Issue: Multiple virtual environments consuming space

**Solution:**
1. Find all virtual environments:
   ```bash
   find ~ -maxdepth 3 -type d -name "venv" -o -name "env"
   ```
2. Remove unused ones
3. Consider using a single environment for similar projects

### Issue: PyTorch too large

**Solution:**
Use CPU-only version:
```bash
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
```

Or use cloud platforms:
- Google Colab (free GPU access)
- Kaggle Notebooks
- AWS SageMaker

## Alternative Solutions

### Use Conda

Conda can sometimes manage dependencies more efficiently:

```bash
# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Create environment
conda create -n ai_wealth python=3.11
conda activate ai_wealth

# Install packages
conda install pytorch cpuonly -c pytorch
pip install --no-cache-dir python-dotenv openai pinecone-client pymilvus sentence-transformers transformers beautifulsoup4 requests pandas
```

### Use Cloud Platforms

For AI/ML development, consider using cloud platforms that come pre-configured:

- **Google Colab**: Free Jupyter notebooks with GPU
- **Kaggle Notebooks**: Free environment with datasets
- **AWS SageMaker**: Professional ML platform
- **Azure ML**: Microsoft's ML platform
- **Paperspace Gradient**: GPU instances for ML

### Use Docker

Create a Docker container with optimized layers:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip

COPY . .

CMD ["python", "main.py"]
```

## Package Size Reference

Approximate download sizes:

| Package | Size | Notes |
|---------|------|-------|
| torch (GPU) | ~900 MB | CUDA version |
| torch (CPU) | ~200 MB | CPU-only version |
| transformers | ~10 MB | Base package |
| sentence-transformers | ~500 KB | Base package |
| pandas | ~11 MB | With dependencies |
| numpy | ~15 MB | Included with pandas |
| tensorflow | ~500 MB | Alternative ML framework |

**Note:** ML packages may download additional models at runtime.

## System Requirements

### Minimum Disk Space

- **Basic installation**: 2-3 GB free space
- **With PyTorch GPU**: 5-6 GB free space
- **Recommended**: 10+ GB free space

### Recommended Setup

- Python 3.8 or higher
- Virtual environment tool (venv or conda)
- 10+ GB available disk space
- Good internet connection for downloads

## Additional Resources

- [Detailed Solutions Guide](DISK_SPACE_SOLUTIONS.md) - Comprehensive troubleshooting
- [Pip Documentation - Caching](https://pip.pypa.io/en/stable/topics/caching/)
- [PyTorch Installation Guide](https://pytorch.org/get-started/locally/)
- [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html)

## Contributing

If you encounter other disk space issues or have solutions to share, please contribute!

## License

This project is open source and available for use in any project.

## Support

If you continue to have issues:

1. Run `bash check_disk_space.sh` to analyze the problem
2. Check [DISK_SPACE_SOLUTIONS.md](DISK_SPACE_SOLUTIONS.md) for detailed solutions
3. Consider using cloud platforms for resource-intensive ML work

---

**Quick Commands Reference:**

```bash
# Check disk space
bash check_disk_space.sh

# Clean up
bash cleanup_disk.sh

# Install packages
bash install_packages.sh

# Verify installation
python verify_installation.py

# Manual cleanup
pip cache purge
find . -type d -name __pycache__ -exec rm -rf {} +

# Manual install with no cache
pip install --no-cache-dir -r requirements.txt
```
