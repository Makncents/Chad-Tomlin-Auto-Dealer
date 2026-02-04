#!/bin/bash
# Smart Package Installation Script
# Installs packages in stages to minimize disk space issues

set -e  # Exit on error

echo "=========================================="
echo "    AI WEALTH PACKAGE INSTALLER          "
echo "=========================================="
echo ""

# Check if we're in a virtual environment
if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "⚠️  WARNING: No virtual environment detected!"
    echo "   Please activate your virtual environment first:"
    echo "   source ai_wealth/bin/activate"
    echo ""
    read -p "Continue anyway? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        exit 1
    fi
fi

# Check available disk space
available=$(df / | tail -1 | awk '{print $4}')
available_mb=$((available / 1024))
echo "📊 Available disk space: ${available_mb} MB"
echo ""

if [[ $available_mb -lt 2500 ]]; then
    echo "⚠️  WARNING: Less than 2.5 GB available!"
    echo "   You may run out of space during installation."
    echo "   Consider running: pip cache purge"
    echo ""
    read -p "Continue anyway? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        exit 1
    fi
fi

# Clear pip cache first
echo "🧹 Clearing pip cache..."
pip cache purge 2>/dev/null || true
echo ""

# Stage 1: Core utilities
echo "📦 Stage 1/5: Installing core utilities..."
pip install --no-cache-dir python-dotenv requests beautifulsoup4 certifi urllib3 tqdm
echo "✅ Stage 1 complete!"
echo ""

# Stage 2: Data processing
echo "📦 Stage 2/5: Installing data processing packages..."
pip install --no-cache-dir pandas orjson python-dateutil
echo "✅ Stage 2 complete!"
echo ""

# Stage 3: OpenAI and Pinecone
echo "📦 Stage 3/5: Installing API clients..."
pip install --no-cache-dir openai pinecone-client
echo "✅ Stage 3 complete!"
echo ""

# Stage 4: PyMilvus
echo "📦 Stage 4/5: Installing Milvus client..."
pip install --no-cache-dir grpcio protobuf pymilvus
echo "✅ Stage 4 complete!"
echo ""

# Stage 5: PyTorch and ML packages
echo "📦 Stage 5/5: Installing ML packages..."
echo "   Using CPU-only PyTorch to save ~1GB of space..."
echo ""

# Ask about GPU support
read -p "Do you need GPU/CUDA support? (y/N): " need_gpu
if [[ "$need_gpu" == "y" || "$need_gpu" == "Y" ]]; then
    echo "   Installing PyTorch with CUDA support (larger download)..."
    pip install --no-cache-dir torch
else
    echo "   Installing CPU-only PyTorch..."
    pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu
fi

pip install --no-cache-dir sentence-transformers transformers huggingface-hub
echo "✅ Stage 5 complete!"
echo ""

echo "=========================================="
echo "     ✅ ALL PACKAGES INSTALLED!          "
echo "=========================================="
echo ""
echo "You can now use your AI wealth management tools."
echo "To verify installation, run:"
echo "   python -c \"import openai, pinecone, pymilvus, torch; print('All imports successful!')\""
echo ""
