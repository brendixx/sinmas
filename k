import os
import html
import textwrap
from openai import OpenAI

# It's recommended to set the OPENAI_API_KEY environment variable.
# Example: export OPENAI_API_KEY="your-api-key"

def chunk_text(text: str, max_chars: int = 8000) -> list[str]:
    """
    Chunks text into roughly max_chars sizes, trying not to break paragraphs.
    """
    paragraphs = text.split('\n\n')
    chunks = []
    current_chunk = []
    current_length = 0
    
    for p in paragraphs:
        if current_length + len(p) > max_chars and current_chunk:
            chunks.append('\n\n'.join(current_chunk))
            current_chunk = [p]
            current_length = len(p)
        else:
            current_chunk.append(p)
            current_length += len(p)
            
    if current_chunk:
        chunks.append('\n\n'.join(current_chunk))
        
    return chunks

def get_visual_aid_for_chunk(chunk: str) -> str:
    """
    Calls the LLM to generate a visual aid (Mermaid.js diagram or HTML table)
    for the provided text chunk, without altering the text itself.
    """
    # If the user hasn't set an API key, we fallback to a mock to avoid crashing.
    if not os.environ.get("OPENAI_API_KEY"):
        return ""
        
    client = OpenAI()
    
    system_prompt = (
        "You are an academic visualizer. Your task is to analyze the provided text and "
        "generate EITHER a <div class='mermaid'>...</div> containing a Mermaid.js diagram OR "
        "an HTML <table> to visually summarize the complex concepts in the text. "
        "DO NOT output any other text or explanation. DO NOT change or rewrite the original text. "
        "Wrap your output in a <div class='visual-aid'><h4>Visual Summary</h4>...</div>. "
        "If the text does not contain complex concepts suitable for visualization, return an empty string."
    )
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Text:\n{chunk}"}
            ],
            temperature=0.2,
            max_tokens=500
        )
        aid = response.choices[0].message.content.strip()
        if "visual-aid" in aid:
            return aid
        return ""
    except Exception as e:
        print(f"Error calling OpenAI API: {e}")
        return ""

def enrich_text_with_ai(text: str) -> str:
    """
    Sends chunks of text to an LLM to insert study aids,
    Mermaid diagrams, and HTML tables, while preserving 100% of the original text.
    Also escapes HTML to ensure proper rendering.
    """
    chunks = chunk_text(text)
    
    html_output = []
    
    for i, chunk in enumerate(chunks):
        # 1. Escape HTML in the chunk to prevent broken rendering
        # 2. Wrap original paragraphs in <p> tags
        paragraphs = chunk.split('\n\n')
        chunk_html = []
        for p in paragraphs:
            if p.strip():
                escaped_p = html.escape(p.strip())
                chunk_html.append(f"<p>{escaped_p}</p>")
                
        # Join paragraphs for this chunk
        html_output.append("\n".join(chunk_html))
        
        # 3. Call LLM for this chunk
        visual_aid = get_visual_aid_for_chunk(chunk)
        if visual_aid:
            html_output.append(visual_aid)
            
    enriched_content = "\n".join(html_output)
    
    return enriched_content
