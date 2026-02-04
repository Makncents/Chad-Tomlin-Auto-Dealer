#!/usr/bin/env python3
"""
Verify Package Installation Script
This script checks if all required packages are installed and working correctly.
"""

import sys
from importlib import import_module

# List of packages to verify
REQUIRED_PACKAGES = [
    ("dotenv", "python-dotenv"),
    ("openai", "openai"),
    ("pinecone", "pinecone-client"),
    ("pymilvus", "pymilvus"),
    ("sentence_transformers", "sentence-transformers"),
    ("transformers", "transformers"),
    ("bs4", "beautifulsoup4"),
    ("requests", "requests"),
    ("pandas", "pandas"),
    ("torch", "torch"),
]

def check_package(module_name, package_name):
    """Check if a package can be imported."""
    try:
        module = import_module(module_name)
        version = getattr(module, "__version__", "unknown")
        return True, version
    except ImportError as e:
        return False, str(e)

def main():
    """Main verification function."""
    print("=" * 60)
    print("Package Installation Verification")
    print("=" * 60)
    print()
    
    all_installed = True
    results = []
    
    for module_name, package_name in REQUIRED_PACKAGES:
        success, info = check_package(module_name, package_name)
        results.append((package_name, success, info))
        
        if success:
            print(f"✓ {package_name:25s} v{info}")
        else:
            print(f"✗ {package_name:25s} NOT INSTALLED")
            all_installed = False
    
    print()
    print("=" * 60)
    
    if all_installed:
        print("✓ All packages are installed and working correctly!")
        print()
        
        # Additional checks
        print("Additional Information:")
        print("-" * 60)
        
        # Check PyTorch configuration
        try:
            import torch
            print(f"PyTorch version: {torch.__version__}")
            print(f"CUDA available: {torch.cuda.is_available()}")
            if torch.cuda.is_available():
                print(f"CUDA version: {torch.version.cuda}")
            else:
                print("Running CPU-only version (smaller, good for saving space)")
        except Exception as e:
            print(f"Could not check PyTorch configuration: {e}")
        
        print()
        
        # Check transformers
        try:
            from transformers import __version__ as transformers_version
            print(f"Transformers version: {transformers_version}")
        except Exception as e:
            print(f"Could not check transformers: {e}")
        
        print()
        print("You're ready to start developing!")
        return 0
    else:
        print("✗ Some packages are missing!")
        print()
        print("To install missing packages, run:")
        print("  pip install --no-cache-dir -r requirements.txt")
        print()
        print("Or use the installation script:")
        print("  bash install_packages.sh")
        return 1

if __name__ == "__main__":
    sys.exit(main())
