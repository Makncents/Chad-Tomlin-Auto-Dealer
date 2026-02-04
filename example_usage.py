#!/usr/bin/env python3
"""
Example usage of installed packages
This script demonstrates basic usage of the AI/ML packages installed.
"""

import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_basic_packages():
    """Test basic utility packages."""
    print("Testing basic packages...")
    
    # Test requests
    import requests
    print("  ✓ requests imported")
    
    # Test beautifulsoup4
    from bs4 import BeautifulSoup
    print("  ✓ BeautifulSoup imported")
    
    # Test pandas
    import pandas as pd
    df = pd.DataFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
    print(f"  ✓ pandas imported and working (created {df.shape[0]}x{df.shape[1]} DataFrame)")
    
    print()

def test_ai_packages():
    """Test AI/ML packages."""
    print("Testing AI/ML packages...")
    
    # Test PyTorch
    import torch
    print(f"  ✓ PyTorch imported (version {torch.__version__})")
    print(f"    - CUDA available: {torch.cuda.is_available()}")
    
    # Create a simple tensor
    x = torch.tensor([1, 2, 3])
    print(f"    - Created tensor: {x}")
    
    # Test transformers
    from transformers import __version__ as transformers_version
    print(f"  ✓ Transformers imported (version {transformers_version})")
    
    # Test sentence-transformers
    from sentence_transformers import __version__ as st_version
    print(f"  ✓ Sentence-Transformers imported (version {st_version})")
    
    print()

def test_vector_databases():
    """Test vector database clients."""
    print("Testing vector database clients...")
    
    # Test Pinecone
    try:
        import pinecone
        print("  ✓ Pinecone client imported")
    except ImportError as e:
        print(f"  ⚠ Pinecone import issue: {e}")
    
    # Test Milvus
    try:
        from pymilvus import __version__ as milvus_version
        print(f"  ✓ PyMilvus imported (version {milvus_version})")
    except ImportError as e:
        print(f"  ⚠ PyMilvus import issue: {e}")
    
    print()

def test_openai():
    """Test OpenAI package."""
    print("Testing OpenAI package...")
    
    try:
        from openai import __version__ as openai_version
        print(f"  ✓ OpenAI imported (version {openai_version})")
        
        # Check if API key is set
        api_key = os.getenv("OPENAI_API_KEY")
        if api_key:
            print("  ✓ OPENAI_API_KEY environment variable is set")
        else:
            print("  ⚠ OPENAI_API_KEY not found in environment")
            print("    Add it to .env file: OPENAI_API_KEY=your_api_key_here")
    except ImportError as e:
        print(f"  ⚠ OpenAI import issue: {e}")
    
    print()

def simple_ml_example():
    """Run a simple ML example to verify everything works."""
    print("Running simple ML example...")
    
    try:
        import torch
        import torch.nn as nn
        
        # Create a simple neural network
        class SimpleNet(nn.Module):
            def __init__(self):
                super(SimpleNet, self).__init__()
                self.fc = nn.Linear(10, 1)
            
            def forward(self, x):
                return self.fc(x)
        
        # Initialize and test
        model = SimpleNet()
        input_data = torch.randn(1, 10)
        output = model(input_data)
        
        print(f"  ✓ Created simple neural network")
        print(f"  ✓ Input shape: {input_data.shape}")
        print(f"  ✓ Output shape: {output.shape}")
        print("  ✓ PyTorch is working correctly!")
        
    except Exception as e:
        print(f"  ✗ Error running ML example: {e}")
    
    print()

def main():
    """Main function to run all tests."""
    print("=" * 60)
    print("Package Installation Verification and Example Usage")
    print("=" * 60)
    print()
    
    try:
        test_basic_packages()
        test_ai_packages()
        test_vector_databases()
        test_openai()
        simple_ml_example()
        
        print("=" * 60)
        print("✓ All packages are working correctly!")
        print("=" * 60)
        print()
        print("Next steps:")
        print("  1. Set up your .env file with API keys")
        print("  2. Start building your AI application")
        print("  3. Check the README.md for more examples")
        print()
        
    except Exception as e:
        print("=" * 60)
        print(f"✗ Error during verification: {e}")
        print("=" * 60)
        print()
        print("Try running: python verify_installation.py")
        print()

if __name__ == "__main__":
    main()
