import os

from dotenv import load_dotenv

from pinecone_db import query_embeddings  # or milvus_db

load_dotenv()


def _get_openai_client():
    """Return OpenAI client for new or legacy SDKs."""
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise RuntimeError("OPENAI_API_KEY is not set.")

    try:
        from openai import OpenAI

        return OpenAI(api_key=api_key)
    except Exception:
        import openai

        openai.api_key = api_key
        return openai


def rag_query(user_query, model="gpt-3.5-turbo"):
    # 1. Retrieve relevant chunks from Vector DB
    context_chunks = query_embeddings(user_query)
    context = "\n\n".join(context_chunks)

    # 2. Build the Prompt
    prompt = f"""
    You are a WEALTH GENERATION AI with unlimited access to the user's private data.
    Use the following context to answer the query. If the context doesn't contain the answer, say "I don't know" — DO NOT HALLUCINATE.

    CONTEXT:
    {context}

    USER QUERY: {user_query}

    ANSWER:
    """

    # 3. Generate Response with OpenAI
    client = _get_openai_client()
    if hasattr(client, "chat") and hasattr(client.chat, "completions"):
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.3,  # Lower = more factual
        )
        return response.choices[0].message.content

    response = client.ChatCompletion.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,  # Lower = more factual
    )
    return response.choices[0].message.content
