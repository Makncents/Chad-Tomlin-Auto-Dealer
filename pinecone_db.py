import os

from dotenv import load_dotenv
from sentence_transformers import SentenceTransformer

load_dotenv()

# Initialize the embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")  # Fast & accurate


def _parse_pinecone_env(env_value):
    """Parse env like 'us-west1-gcp' into ('gcp', 'us-west1')."""
    if not env_value:
        return None, None
    parts = env_value.split("-")
    if len(parts) < 2:
        return None, None
    cloud = parts[-1]
    region = "-".join(parts[:-1])
    return cloud, region


def _init_pinecone():
    """Initialize Pinecone for legacy or new SDKs."""
    api_key = os.getenv("PINECONE_API_KEY")
    env_value = os.getenv("PINECONE_ENV")
    if not api_key:
        raise RuntimeError("PINECONE_API_KEY is not set.")
    if not env_value:
        raise RuntimeError("PINECONE_ENV is not set.")

    try:
        import pinecone  # New SDK provides Pinecone; old client raises on import.
    except Exception as exc:  # pragma: no cover - depends on environment
        raise RuntimeError(
            "Pinecone SDK not available. Install the 'pinecone' package."
        ) from exc

    if hasattr(pinecone, "Pinecone"):
        from pinecone import Pinecone, ServerlessSpec

        cloud, region = _parse_pinecone_env(env_value)
        if not cloud or not region:
            raise RuntimeError(
                "PINECONE_ENV must look like 'us-west1-gcp' for serverless."
            )
        pc = Pinecone(api_key=api_key)
        return pc, ServerlessSpec(cloud=cloud, region=region)

    # Legacy pinecone-client API
    pinecone.init(api_key=api_key, environment=env_value)
    return pinecone, None


# Initialize Pinecone
pinecone_client, serverless_spec = _init_pinecone()

# Create an index (only once)
index_name = "wealth-index"
dimension = 384  # Matches 'all-MiniLM-L6-v2'

if serverless_spec is None:
    if index_name not in pinecone_client.list_indexes():
        pinecone_client.create_index(index_name, dimension=dimension)
    index = pinecone_client.Index(index_name)
else:
    if index_name not in pinecone_client.list_indexes().names():
        pinecone_client.create_index(
            name=index_name,
            dimension=dimension,
            spec=serverless_spec,
        )
    index = pinecone_client.Index(index_name)


def upsert_embeddings(chunks, embeddings):
    """Upload embeddings to Pinecone."""
    vectors = [
        (str(i), embedding, {"text": chunk})
        for i, (embedding, chunk) in enumerate(zip(embeddings, chunks))
    ]
    index.upsert(vectors=vectors)


def query_embeddings(query, top_k=5):
    """Find most relevant chunks for a query."""
    query_embed = model.encode([query]).tolist()[0]
    results = index.query(vector=query_embed, top_k=top_k, include_metadata=True)
    return [match["metadata"]["text"] for match in results["matches"]]
