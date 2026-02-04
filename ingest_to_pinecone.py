from data_loader import load_and_chunk_data, generate_embeddings
from pinecone_db import upsert_embeddings

chunks = load_and_chunk_data("your_data/stock_analysis.txt")
embeddings = generate_embeddings(chunks)
upsert_embeddings(chunks, embeddings)
print("Your data is NOW in the vector DB!")
