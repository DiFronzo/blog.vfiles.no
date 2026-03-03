---
title: "Building a Rag Chatbot for Norwegian Legal Texts"
date: 2025-11-10T22:12:33+01:00
draft: true
toc: false
images:
author: Andreas Lien
tags:
  - Lovdata
  - RAG
  - Chatbot
  - Legal texts
  - Laws
  - Gemini
  - Lovdata Pro 2
---

Legal information systems present unique challenges: they require precise retrieval of authoritative sources, handle complex domain-specific language, and must provide accurate, grounded responses. This post explores the technical architecture of a Retrieval-Augmented Generation (RAG) chatbot built to answer questions about Norwegian laws and regulations using **38,803 legal documents** from Lovdata.

Traditional chatbots hallucinate or provide unreliable legal information. Large Language Models (LLMs) alone don't have access to specific legal texts, especially in Norwegian. The solution? RAG—combining semantic search with LLM generation to ensure responses are grounded in actual legal sources.

## Architecture Overview

```
User Query 
    ↓
Embedding Model (text-embedding-004)
    ↓
Vector Search (Chroma DB)
    ↓
Top-K Document Retrieval
    ↓
Context Assembly + System Prompt
    ↓
LLM Generation (Google Gemini)
    ↓
Response with Citations
```

### Tech Stack

- **Language Model**: Google Gemini (gemini-pro-latest)
- **Embeddings**: Google text-embedding-004
- **Vector Database**: Chroma DB with persistent storage
- **Framework**: LangChain for RAG orchestration
- **Frontend**: Streamlit for interactive UI
- **Language**: Python 3.10+

## Data Pipeline: From XML to Embeddings

### 1. Data Preprocessing

The dataset consists of 38,803 XML files from Lovdata:
- **3,318 laws** (files starting with `nl-`)
- **35,485 regulations** (files starting with `sf-`)

**Challenge**: Lovdata's XML files are HTML-formatted, containing navigation elements, metadata, and legal content mixed together.

**Solution**: Custom XML parser that:

```python
def extract_text_from_xml(file_path: Path) -> str:
    """Extract clean legal content from Lovdata HTML/XML."""
    tree = ET.parse(file_path)
    root = tree.getroot()
    
    # Detect document type from filename
    doc_type = "[Lov]" if "nl-" in file_path.name else "[Forskrift]"
    
    # Extract metadata (title, dates, document ID)
    title = root.find(".//title")
    metadata = extract_metadata(root)
    
    # Skip navigation/headers, focus on main content
    main_content = root.find(".//main[@class='documentBody']")
    
    # Preserve legal structure (§ sections)
    sections = extract_sections(main_content)
    
    return f"{doc_type} {title}\n\nMetadata: {metadata}\n\n{sections}"
```

**Key Features**:
- Distinguishes between laws and regulations
- Extracts titles and metadata (document IDs, effective dates)
- Filters out navigation, headers, footnotes
- Preserves section structure (§1, §2, etc.)
- Handles malformed documents gracefully

**Performance**: 
- Processing time: ~3-4 hours for full dataset
- Output: ~1 million chunks (~500-600 MB)

### 2. Text Chunking

Legal texts need intelligent chunking to maintain context:

```python
def split_into_chunks(text: str, chunk_size: int = 500, 
                      overlap: int = 50) -> List[Dict]:
    """Split text into overlapping chunks using tiktoken."""
    sentences = re.split(r'(?<=[.!?])\s+', text)
    
    chunks = []
    current_chunk = []
    current_tokens = 0
    
    for sentence in sentences:
        tokens = count_tokens(sentence)
        
        if current_tokens + tokens > chunk_size and current_chunk:
            # Save current chunk and start new with overlap
            chunks.append(create_chunk(current_chunk))
            # Keep last few sentences for overlap
            current_chunk = get_overlap(current_chunk, overlap)
            current_tokens = count_tokens_batch(current_chunk)
        
        current_chunk.append(sentence)
        current_tokens += tokens
    
    return chunks
```

**Strategy**:
- Chunk size: 500 tokens (balances context vs. precision)
- Overlap: 50 tokens (preserves context across boundaries)
- Sentence-based splitting (maintains semantic coherence)
- Uses `tiktoken` with `cl100k_base` encoding (GPT-4 tokenizer)

### 3. Embedding Generation

Converting text chunks to vector representations:

```python
embeddings = GoogleGenerativeAIEmbeddings(
    model="models/text-embedding-004",
    google_api_key=GEMINI_API_KEY
)

# Batch processing to handle rate limits
batch_size = 100
for i in range(0, len(documents), batch_size):
    batch = documents[i:i + batch_size]
    vectorstore.add_documents(batch)
    vectorstore.persist()
```

**Rate Limit Considerations**:
- Free tier: 2 requests/minute (163 hours for full dataset!)
- With billing: 1,500 requests/minute (13 minutes)
- Solution: Batch processing + error handling

**Vector Store**: Chroma DB
- Persistent local storage
- Fast similarity search (approximate nearest neighbors)
- Metadata filtering support

## RAG Pipeline Implementation

### Retrieval Phase

```python
def retrieve_documents(self, query: str, k: int = 5) -> List[Document]:
    """Semantic search for relevant legal texts."""
    # Query is automatically embedded by Chroma
    results = self.vectorstore.similarity_search(query, k=k)
    return results
```

**Retrieval Strategy**:
- Top-K retrieval (default K=5)
- Cosine similarity in embedding space
- Returns documents with metadata (source, chunk index)

### Context Assembly

```python
def format_context(self, documents: List[Document]) -> str:
    """Format retrieved docs for LLM consumption."""
    context_parts = []
    
    for i, doc in enumerate(documents, 1):
        source = doc.metadata.get('source', 'Ukjent')
        context_parts.append(
            f"[Kilde {i}: {source}]\n{doc.page_content}"
        )
    
    return "\n\n".join(context_parts)
```

### Generation Phase

The system prompt is carefully crafted to ensure grounded responses:

```python
def create_system_prompt(self, context: str) -> str:
    return f"""Du er en ekspert på norsk lovgivning og hjelper brukere 
med å forstå lover og forskrifter.

VIKTIGE REGLER:
1. Du må BARE svare basert på informasjonen gitt i konteksten nedenfor
2. Hvis informasjonen ikke finnes i konteksten, si tydelig at du ikke 
   har nok informasjon
3. Referer alltid til kildene når du siterer eller refererer til lovtekst
4. Svar på norsk med klar og forståelig juridisk terminologi
5. Vær presis og faktabasert - ikke spekuler

KONTEKST FRA NORSK LOVTIDEND:
{context}

Basert på konteksten ovenfor, svar på brukerens spørsmål."""
```

**Key Design Decisions**:
- Strict instruction to only use provided context (reduces hallucination)
- Explicit requirement to cite sources
- Norwegian language instruction
- Professional legal terminology

## Model Selection & Fallback Strategy

**Challenge**: Google's model naming/availability changes frequently. Initial model `gemini-1.5-pro` returned 404 errors.

**Solution**: Implemented automatic fallback logic:

```python
def _initialize_llm(self):
    """Try models in order until one works."""
    models = [
        self.gemini_model,           # User's choice
        "gemini-2.5-pro",            # Latest stable
        "gemini-2.5-flash",          # Fast alternative
        "gemini-2.0-flash",          # Fallback
    ]
    
    for model_name in models:
        try:
            llm = ChatGoogleGenerativeAI(
                model=model_name,
                google_api_key=self.api_key
            )
            # Ping test before committing
            llm.invoke([HumanMessage(content="test")])
            print(f"✓ Using model: {model_name}")
            self.llm = llm
            return
        except Exception as e:
            print(f"✗ {model_name} failed: {e}")
            continue
    
    raise RuntimeError("No available Gemini models")
```

**Benefits**:
- Resilient to API changes
- Automatic failover
- User feedback on which model is active

## Streamlit UI

The frontend provides:
- Chat interface with history
- Source document display (expandable sections)
- Configurable retrieval parameters (top-K)
- Example questions for quick start

**Key Implementation Detail**: Fixed duplicate element keys issue:

```python
def display_chat_history():
    for chat_idx, item in enumerate(st.session_state.chat_history):
        # Use chat_idx to ensure unique keys across reruns
        for i, source in enumerate(item.get('sources', [])):
            st.text_area(
                f"Kilde {i+1}",
                value=source.page_content,
                key=f"source_{chat_idx}_{i}",  # Unique across history
                height=150
            )
```

## Performance & Scalability

### Processing Metrics
- **Preprocessing**: 3-4 hours for 38,803 documents
- **Embedding**: 13 minutes (with billing) vs. 163 hours (free tier)
- **Query latency**: ~2-3 seconds (retrieval + generation)

### Optimization Strategies
1. **Batch Processing**: Process documents in groups of 100
2. **Progress Tracking**: Updates every 100 files (reduces I/O)
3. **Error Handling**: Continue on failure, log errors
4. **Persistent Storage**: Chroma DB with disk persistence

### Scalability Considerations
- Vector DB size: ~2-3 GB for 1M chunks
- Memory usage: ~4-6 GB during embedding generation
- Query cost: 1 embedding + 1 LLM call per query

## Challenges & Solutions

### 1. Package Version Conflicts
**Problem**: LangChain 0.2.x introduced breaking changes, incompatible with langchain-google-genai 0.0.11.

**Solution**: Pin compatible versions:
```txt
langchain>=0.1.0,<0.2.0
langchain-google-genai==0.0.11
google-generativeai<0.7.0
```

### 2. Deprecated Imports
**Problem**: `langchain.schema` moved to `langchain_core`.

**Solution**: Update imports:
```python
# Old
from langchain.schema import Document
# New
from langchain_core.documents import Document
```

### 3. Rate Limiting
**Problem**: Free tier limited to 2 RPM (impractical for large datasets).

**Solution**: 
- Batch processing with retry logic
- Optional `MAX_CHUNKS` env var for testing
- Documentation recommending billing enablement

### 4. Lovdata XML Structure
**Problem**: Generic XML parsing produced noisy output.

**Solution**: Custom parser tailored to Lovdata's HTML/XML format with element filtering.

## Results & Example Queries

### Query
> "I hvilken grad kan arbeidsgiver overvåke ansattes e-post uten å bryte personvernlovgivningen?"

### Response
> Basert på arbeidsmiljøloven § 9-1 kan arbeidsgiver kun gjennomføre kontroll som ikke er av mer omfattende art enn formålet tilsier. Personvernlovgivningen stiller også krav om:
> 1. Behandlingsgrunnlag (GDPR art. 6)
> 2. Informasjonsplikt til ansatte
> 3. Proporsjonalitetsvurdering
> 
> [Kilder: arbeidsmiljøloven § 9-1, personopplysningsloven § 3]

## Lessons Learned

1. **LangChain versions matter**: Pin dependencies carefully
2. **Model availability changes**: Build fallback logic
3. **Domain-specific parsing**: Generic solutions often inadequate
4. **Rate limits are real**: Budget for API costs or build in delays
5. **Metadata is crucial**: Track sources for citation/debugging
6. **Progress tracking is UX**: Essential for large datasets
7. **Test with subsets**: Use `MAX_CHUNKS` during development

## Future Improvements

### Planned Enhancements
1. **Hybrid Search**: Combine dense (embeddings) + sparse (BM25) retrieval
2. **Re-ranking**: Add cross-encoder model to re-score retrieved chunks
3. **Query Expansion**: Generate multiple query variations
4. **Metadata Filtering**: Filter by law type, date, document ID
5. **Streaming Responses**: Real-time token generation (improve UX)
6. **Citation Formatting**: Link directly to Lovdata URLs
7. **Multi-turn Conversations**: Context-aware follow-up questions
8. **Evaluation Framework**: Automated testing with legal Q&A pairs

### Production Considerations
- Deploy to cloud (GCP Cloud Run, AWS Lambda)
- Add authentication/authorization
- Implement query logging and analytics
- Set up monitoring (query latency, error rates)
- Add feedback mechanism (thumbs up/down)
- Consider model fine-tuning on legal domain

## Conclusion

Building a RAG system for legal texts requires careful consideration of:
- **Data quality**: Custom parsing for domain-specific formats
- **Retrieval precision**: Proper chunking and overlap strategies
- **Generation accuracy**: Strict system prompts to reduce hallucination
- **Engineering resilience**: Fallback logic and error handling
- **Scale planning**: Rate limits and processing time estimates

The result is a system that provides **accurate, source-grounded answers** to Norwegian legal questions, demonstrating RAG's power for domain-specific applications.

Check processing logs: Look for errors related to nl-20050617-062.xml
Reprocess the file: Ensure arbeidsmiljøloven gets indexed
Verify completeness: 38,803 files claimed, but at least one major law is missing
