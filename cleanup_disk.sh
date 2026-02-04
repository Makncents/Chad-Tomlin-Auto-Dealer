#!/bin/bash

# Disk Space Cleanup Script for Python Development
# This script helps free up disk space for package installations

set -e

echo "=== Disk Space Cleanup Script ==="
echo ""

# Function to print size in human-readable format
print_size() {
    local path=$1
    local name=$2
    if [ -d "$path" ] || [ -f "$path" ]; then
        size=$(du -sh "$path" 2>/dev/null | cut -f1)
        echo "  $name: $size"
    fi
}

# Check current disk usage
echo "1. Current Disk Usage:"
df -h | grep -E "Filesystem|/$|/home"
echo ""

# Check pip cache
echo "2. Checking Pip Cache:"
if command -v pip &> /dev/null; then
    pip cache info || echo "  Could not get pip cache info"
else
    echo "  pip not found"
fi
echo ""

# Show what will be cleaned
echo "3. Analyzing directories to clean:"
print_size "$HOME/.cache/pip" "Pip cache"
print_size "/tmp" "Temporary files"
print_size "$HOME/.cache" "User cache"

# Count __pycache__ directories
pycache_count=$(find . -type d -name __pycache__ 2>/dev/null | wc -l)
echo "  Python cache directories: $pycache_count"
echo ""

# Ask for confirmation
read -p "Do you want to proceed with cleanup? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "4. Starting cleanup..."
echo ""

# Clean pip cache
echo "  Cleaning pip cache..."
if command -v pip &> /dev/null; then
    pip cache purge 2>/dev/null || echo "    Could not purge pip cache"
    echo "    ✓ Pip cache purged"
else
    echo "    - pip not found, skipping"
fi

# Clean pip cache directory
if [ -d "$HOME/.cache/pip" ]; then
    echo "  Removing pip cache directory..."
    rm -rf "$HOME/.cache/pip"
    echo "    ✓ Removed $HOME/.cache/pip"
fi

# Clean Python bytecode
echo "  Removing Python bytecode cache..."
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -type f -name "*.pyo" -delete 2>/dev/null || true
echo "    ✓ Python bytecode removed"

# Clean temporary pip files
echo "  Cleaning temporary pip files..."
rm -rf /tmp/pip-* 2>/dev/null || true
echo "    ✓ Temporary pip files removed"

# Clean build artifacts
if [ -d "build" ]; then
    echo "  Removing build directory..."
    rm -rf build
    echo "    ✓ Build directory removed"
fi

if [ -d "dist" ]; then
    echo "  Removing dist directory..."
    rm -rf dist
    echo "    ✓ Dist directory removed"
fi

if [ -d "*.egg-info" ]; then
    echo "  Removing egg-info directories..."
    rm -rf *.egg-info
    echo "    ✓ Egg-info removed"
fi

# Clean pytest cache
if [ -d ".pytest_cache" ]; then
    echo "  Removing pytest cache..."
    rm -rf .pytest_cache
    echo "    ✓ Pytest cache removed"
fi

# Clean coverage files
if [ -f ".coverage" ]; then
    echo "  Removing coverage files..."
    rm -f .coverage
    echo "    ✓ Coverage files removed"
fi

echo ""
echo "5. Cleanup Summary:"
echo ""

# Show disk usage after cleanup
echo "  Disk usage after cleanup:"
df -h | grep -E "Filesystem|/$|/home"
echo ""

echo "✓ Cleanup complete!"
echo ""
echo "Next steps:"
echo "  1. Try installing packages with: pip install --no-cache-dir <package_name>"
echo "  2. For large packages like PyTorch, consider CPU-only version:"
echo "     pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu"
echo "  3. See DISK_SPACE_SOLUTIONS.md for more options"
echo ""
