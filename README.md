# Chad-Tomlin-Auto-Dealer

AI-powered wealth management application using vector databases and language models.

## Setup

### Create Virtual Environment

```bash
# Create virtual environment
python3 -m venv ai_wealth

# Activate virtual environment
source ai_wealth/bin/activate  # Linux/Mac
ai_wealth\Scripts\activate     # Windows
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Core Packages

- **python-dotenv** - Environment variable management
- **openai** - OpenAI API client
- **pinecone** - Pinecone vector database
- **pymilvus** - Milvus vector database
- **sentence-transformers** - Sentence embeddings
- **transformers** - Hugging Face transformers
- **beautifulsoup4** - HTML/XML parsing
- **requests** - HTTP library
- **pandas** - Data manipulation

## Environment Variables

Create a `.env` file with your API keys:

```
OPENAI_API_KEY=your_openai_key
PINECONE_API_KEY=your_pinecone_key
```