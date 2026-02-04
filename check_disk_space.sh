#!/bin/bash

# Disk Space Analysis Script for Python Development
# This script analyzes disk usage and provides recommendations

echo "=== Disk Space Analysis ==="
echo ""

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "OK" ]; then
        echo "  ✓ $message"
    elif [ "$status" = "WARNING" ]; then
        echo "  ⚠ $message"
    elif [ "$status" = "ERROR" ]; then
        echo "  ✗ $message"
    else
        echo "  $message"
    fi
}

# 1. Check overall disk space
echo "1. Overall Disk Space:"
df -h | grep -E "Filesystem|/$|/home"
echo ""

# Get available space in GB
available=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
echo "  Available space: ${available}GB"

if [ "$available" -gt 10 ]; then
    print_status "OK" "Sufficient space available"
elif [ "$available" -gt 5 ]; then
    print_status "WARNING" "Low disk space - consider cleanup"
else
    print_status "ERROR" "Critical: Very low disk space!"
fi
echo ""

# 2. Check pip cache
echo "2. Pip Cache Status:"
if command -v pip &> /dev/null; then
    pip cache info 2>/dev/null || echo "  Could not get pip cache info"
    
    # Get pip cache size
    if [ -d "$HOME/.cache/pip" ]; then
        cache_size=$(du -sh "$HOME/.cache/pip" 2>/dev/null | cut -f1)
        echo "  Cache size: $cache_size"
        echo "  Location: $HOME/.cache/pip"
        echo "  Run 'pip cache purge' to clear"
    fi
else
    echo "  pip not found"
fi
echo ""

# 3. Check for large directories in home
echo "3. Largest Directories in Home (~/):"
du -sh ~/* 2>/dev/null | sort -h | tail -10 | while read -r line; do
    echo "  $line"
done
echo ""

# 4. Check for Python-related space usage
echo "4. Python-Related Disk Usage:"

# Virtual environments
echo "  Virtual Environments:"
find ~ -maxdepth 3 -type d -name "venv" -o -name "env" -o -name ".venv" 2>/dev/null | while read -r venv; do
    size=$(du -sh "$venv" 2>/dev/null | cut -f1)
    echo "    - $venv: $size"
done

# Python cache
pycache_count=$(find . -type d -name __pycache__ 2>/dev/null | wc -l)
if [ "$pycache_count" -gt 0 ]; then
    echo "  Python cache directories (__pycache__): $pycache_count found"
    pycache_size=$(find . -type d -name __pycache__ -exec du -sh {} + 2>/dev/null | awk '{sum+=$1} END {print sum}')
fi

# Pip packages in current venv
if [ -n "$VIRTUAL_ENV" ]; then
    echo "  Current virtual environment: $VIRTUAL_ENV"
    venv_size=$(du -sh "$VIRTUAL_ENV" 2>/dev/null | cut -f1)
    echo "  Size: $venv_size"
fi
echo ""

# 5. Check for large Python packages
echo "5. Installed Package Sizes (current environment):"
if command -v pip &> /dev/null; then
    echo "  Top 10 largest packages:"
    pip list 2>/dev/null | tail -n +3 | while read -r package version; do
        if [ -n "$VIRTUAL_ENV" ]; then
            package_lower=$(echo "$package" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
            pkg_path="$VIRTUAL_ENV/lib/python*/site-packages/$package_lower*"
            size=$(du -sh $pkg_path 2>/dev/null | head -1 | cut -f1)
            if [ -n "$size" ]; then
                echo "$size $package"
            fi
        fi
    done 2>/dev/null | sort -h | tail -10 | while read -r line; do
        echo "    $line"
    done
else
    echo "  pip not found or no virtual environment active"
fi
echo ""

# 6. Recommendations
echo "6. Recommendations:"
echo ""

if [ "$available" -lt 5 ]; then
    echo "  URGENT: Free up disk space immediately!"
    echo "  - Run: bash cleanup_disk.sh"
    echo "  - Remove unused virtual environments"
    echo "  - Clear system cache: sudo apt-get clean (Ubuntu/Debian)"
    echo ""
fi

if [ -d "$HOME/.cache/pip" ]; then
    cache_size=$(du -sm "$HOME/.cache/pip" 2>/dev/null | cut -f1)
    if [ "$cache_size" -gt 100 ]; then
        echo "  Pip cache is large (${cache_size}MB)"
        echo "  - Run: pip cache purge"
        echo ""
    fi
fi

if [ "$pycache_count" -gt 50 ]; then
    echo "  Many Python cache directories found"
    echo "  - Run: find . -type d -name __pycache__ -exec rm -rf {} +"
    echo ""
fi

echo "  General tips:"
echo "  - Always use --no-cache-dir when installing: pip install --no-cache-dir package"
echo "  - Use CPU-only PyTorch if GPU not needed"
echo "  - Consider cloud platforms (Google Colab, Kaggle) for ML work"
echo "  - Remove unused virtual environments regularly"
echo ""

echo "=== Analysis Complete ==="
echo ""
echo "For solutions, see: DISK_SPACE_SOLUTIONS.md"
echo "To clean up, run: bash cleanup_disk.sh"
echo ""
