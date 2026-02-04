#!/bin/bash
# Disk Space Diagnostic and Cleanup Script
# Run this to identify what's using your disk space

echo "=========================================="
echo "       DISK SPACE DIAGNOSTIC TOOL        "
echo "=========================================="
echo ""

# 1. Overall disk usage
echo "📊 OVERALL DISK USAGE:"
echo "----------------------------------------"
df -h / | tail -1 | awk '{print "Total: "$2"  Used: "$3"  Available: "$4"  Usage: "$5}'
echo ""

# 2. Check available space
available=$(df / | tail -1 | awk '{print $4}')
available_gb=$(echo "scale=2; $available/1024/1024" | bc 2>/dev/null || echo "N/A")
echo "Available space: ${available_gb} GB"
echo ""

# 3. pip cache size
echo "📦 PIP CACHE:"
echo "----------------------------------------"
if command -v pip &> /dev/null; then
    pip cache info 2>/dev/null || echo "Could not get pip cache info"
else
    echo "pip not found"
fi
echo ""

# 4. Largest directories in home
echo "📁 LARGEST DIRECTORIES IN HOME:"
echo "----------------------------------------"
du -sh ~/* 2>/dev/null | sort -hr | head -10
echo ""

# 5. Python virtual environments
echo "🐍 PYTHON VIRTUAL ENVIRONMENTS FOUND:"
echo "----------------------------------------"
find ~ -maxdepth 4 -type d -name "site-packages" 2>/dev/null | while read dir; do
    venv_dir=$(dirname $(dirname $(dirname "$dir")))
    size=$(du -sh "$venv_dir" 2>/dev/null | cut -f1)
    echo "$size    $venv_dir"
done | sort -hr | head -10
echo ""

# 6. Large files
echo "📄 LARGE FILES (>100MB):"
echo "----------------------------------------"
find ~ -type f -size +100M 2>/dev/null -exec ls -lh {} \; | awk '{print $5, $9}' | head -10
echo ""

# 7. Recommendations
echo "=========================================="
echo "         CLEANUP RECOMMENDATIONS          "
echo "=========================================="
echo ""
echo "Run these commands to free up space:"
echo ""
echo "  1. Clear pip cache:"
echo "     pip cache purge"
echo ""
echo "  2. Clear apt cache (requires sudo):"
echo "     sudo apt-get clean && sudo apt-get autoremove -y"
echo ""
echo "  3. Clear temp files (requires sudo):"
echo "     sudo rm -rf /tmp/* /var/tmp/*"
echo ""
echo "  4. Clear old logs (requires sudo):"
echo "     sudo journalctl --vacuum-time=7d"
echo ""
echo "  5. Remove unused virtual environments:"
echo "     rm -rf /path/to/old/venv"
echo ""
