[README.md](https://github.com/user-attachments/files/33440753/README.md)
# Academic PDF Redesigner & Visual Enricher

This project is a complete web application that allows users to upload unformatted, dense academic PDFs and generates a redesigned, visually enriched, highly aesthetic PDF. It is built to handle massive documents (up to 1,000+ pages) without timeouts or memory crashes.

## 🏗️ Architecture & Tech Stack

### Backend
- **Framework:** Python FastAPI (for high-performance API endpoints)
- **Task Queue:** Celery + Redis (for handling heavy-duty async processing of large PDFs)
- **PDF Extraction:** PyMuPDF (`fitz`) (for extremely fast and reliable text extraction)
- **AI Enrichment:** OpenAI API (for generating Mermaid.js diagrams, HTML tables, and contextual aids without altering original text)
- **PDF Generation:** Playwright (Python) + Jinja2 (for rendering a responsive, highly styled HTML template into a beautifully formatted PDF)

### Frontend
- **Framework:** React + Vite
- **Styling:** Tailwind CSS (for quick, modern, and aesthetic UI components)
- **File Upload:** `react-dropzone` (for drag-and-drop functionality)
- **State Management & Fetching:** Axios & React Hooks (for real-time progress polling)

## 📁 Project Structure

```
project/
├── README.md
├── docker-compose.yml       # For easily spinning up Redis
├── backend/
│   ├── requirements.txt     # Python dependencies
│   ├── main.py              # FastAPI application & endpoints
│   ├── celery_app.py        # Celery configuration
│   ├── tasks.py             # Async worker tasks
│   ├── pdf_processor.py     # Logic for text extraction & smart cleanup (regex)
│   ├── ai_enrichment.py     # LLM integration for injecting diagrams/aids
│   ├── pdf_generator.py     # HTML-to-PDF generation (Playwright/WeasyPrint)
│   └── templates/
│       └── document.html    # Jinja2 template with beige background & typography
└── frontend/
    ├── package.json
    ├── vite.config.js
    ├── index.html
    ├── src/
    │   ├── App.jsx          # Main React component
    │   ├── main.jsx
    │   ├── index.css        # Tailwind imports & custom styles
    │   └── components/
    │       ├── FileUploader.jsx
    │       ├── ProgressTracker.jsx
    │       └── DownloadPortal.jsx
```

## 🚀 Key Features

1. **Heavy-Duty Processing**: Uses Celery to queue PDF parsing. Users get a task ID and the frontend polls for progress.
2. **Inviolable Engine**: Employs Regex to clean up citation artifacts and empty gaps while preserving 100% of original words in the exact sequence.
3. **AI-Driven Visuals**: Chunks the text and calls an LLM to smartly insert `<div class="mermaid">` tags and `<table>` blocks.
4. **Aesthetic Design**: The final output has a `#FAF8F5` background, modern typography (Inter), 1.5 line spacing, and harmonic colors.
