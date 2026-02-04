#!/bin/bash

# Safe Package Installation Script
# This script installs Python packages with disk space optimization

set -e

echo "=== Safe Package Installation Script ==="
echo ""

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠ WARNING: No virtual environment detected!"
    echo ""
    echo "It's recommended to use a virtual environment."
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        echo ""
        echo "To create and activate a virtual environment:"
        echo "  python -m venv ai_wealth"
        echo "  source ai_wealth/bin/activate  # Linux/Mac"
        echo "  ai_wealth\\Scripts\\activate     # Windows"
        exit 0
    fi
    echo ""
fi

# Check available disk space
available=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
echo "Available disk space: ${available}GB"

if [ "$available" -lt 3 ]; then
    echo "✗ ERROR: Insufficient disk space (less than 3GB available)"
    echo ""
    echo "Please run cleanup first:"
    echo "  bash cleanup_disk.sh"
    exit 1
elif [ "$available" -lt 5 ]; then
    echo "⚠ WARNING: Low disk space (less than 5GB available)"
    echo ""
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        echo "Run 'bash cleanup_disk.sh' to free up space."
        exit 0
    fi
fi

echo ""
echo "Installation Strategy:"
echo "  - Using --no-cache-dir to save disk space"
echo "  - Installing CPU-only PyTorch (smaller size)"
echo "  - Installing in stages to minimize temporary disk usage"
echo ""

# Clean pip cache first
echo "1. Cleaning pip cache..."
pip cache purge 2>/dev/null || true
echo "   ✓ Cache cleaned"
echo ""

# Update pip
echo "2. Updating pip..."
pip install --no-cache-dir --upgrade pip
echo "   ✓ pip updated"
echo ""

# Install lightweight packages first
echo "3. Installing lightweight packages..."
pip install --no-cache-dir python-dotenv requests beautifulsoup4
echo "   ✓ Lightweight packages installed"
echo ""

# Install data processing packages
echo "4. Installing data processing packages..."
pip install --no-cache-dir pandas
echo "   ✓ Data processing packages installed"
echo ""

# Install API clients
echo "5. Installing API clients..."
pip install --no-cache-dir openai pinecone-client pymilvus
echo "   ✓ API clients installed"
echo ""

# Install PyTorch (CPU version)
echo "6. Installing PyTorch (CPU version)..."
echo "   Note: This is the smaller CPU-only version."
echo "   If you need GPU support, install manually with CUDA version."
pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
echo "   ✓ PyTorch installed"
echo ""

# Install transformers and related packages
echo "7. Installing transformers and NLP packages..."
pip install --no-cache-dir transformers sentence-transformers
echo "   ✓ NLP packages installed"
echo ""

# Clean up after installation
echo "8. Post-installation cleanup..."
pip cache purge 2>/dev/null || true
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
echo "   ✓ Cleanup complete"
echo ""

# Verify installation
echo "9. Verifying installation..."
echo ""
echo "Installed packages:"
pip list | grep -E "python-dotenv|openai|pinecone|pymilvus|sentence-transformers|transformers|beautifulsoup4|requests|pandas|torch"
echo ""

# Show final disk usage
echo "10. Final disk usage:"
df -h . | grep -v "Filesystem"
echo ""

echo "✓ Installation complete!"
echo ""
echo "To verify your installation, run:"
echo "  python -c 'import torch; import transformers; import pandas; print(\"All packages working!\")'"
echo ""
