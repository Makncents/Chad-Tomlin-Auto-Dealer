# Chad-Tomlin-Auto-Dealer

## Package Installation Guide

If you encounter a "No space left on device" error while installing Python packages, see the troubleshooting guide:

- **[Disk Space Troubleshooting Guide](disk_space_troubleshooting.md)** - Comprehensive solutions

### Quick Fix

```bash
# 1. Clear pip cache
pip cache purge

# 2. Check disk space
df -h

# 3. Use the smart installer (installs in stages, uses CPU-only PyTorch)
chmod +x install_packages.sh
./install_packages.sh
```

### Helper Scripts

- `check_disk_space.sh` - Diagnose what's using your disk space
- `install_packages.sh` - Install packages in stages to avoid running out of space

### Manual Installation (if disk space is limited)

```bash
# Activate your virtual environment
source ai_wealth/bin/activate

# Install in smaller batches
pip install --no-cache-dir python-dotenv requests beautifulsoup4 pandas
pip install --no-cache-dir openai pinecone-client pymilvus

# Use CPU-only PyTorch to save ~1-2GB
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
pip install --no-cache-dir sentence-transformers transformers
```