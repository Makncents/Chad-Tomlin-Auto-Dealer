import os
import pandas as pd
from sentence_transformers import SentenceTransformer

# Initialize the embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")  # Fast & accurate


def load_and_chunk_data(data_path):
    """Load PDFs, CSVs, TXT files and split into chunks."""
    chunks = []

    if data_path.endswith(".csv"):
        df = pd.read_csv(data_path)
        text = df.to_string(index=False)
    elif data_path.endswith(".txt"):
        with open(data_path, "r") as f:
            text = f.read()
    # Add support for PDFs (use `pypdf` package)

    # Split text into 500-character chunks (with 50-char overlap)
    for i in range(0, len(text), 450):
        chunk = text[i : i + 500]
        chunks.append(chunk)

    return chunks


def generate_embeddings(chunks):
    """Convert text chunks into vector embeddings."""
    return model.encode(chunks).tolist()


# Example Usage
if __name__ == "__main__":
    data_path = "your_data/financial_reports.csv"
    chunks = load_and_chunk_data(data_path)
    embeddings = generate_embeddings(chunks)
    print(f"Generated {len(embeddings)} embeddings!")
