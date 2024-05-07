#!/bin/bash

# Install Ghostscript, Tesseract-OCR, and x11-utils if not already installed
if ! command -v gs &> /dev/null; then
    apt-get update
    apt-get install -y ghostscript tesseract-ocr tesseract-ocr-eng x11-utils
fi

# Following the original entrypoint logic
if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "$@"
else
  # Got started without arguments
  exec n8n
fi