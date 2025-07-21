#!/bin/bash
# run_all.sh - Script to run both FastAPI backend and Streamlit frontend

# Activate virtual environment (make sure this is the correct relative path)
source venv/Scripts/activate

# Check if venv activated correctly
echo "✅ Python used: $(which python)"
echo "✅ Pip used: $(which pip)"
pip show xgboost || { echo "❌ xgboost NOT FOUND in venv"; exit 1; }

# Check Gemini API Key
if [ -z "$GEMINI_API_KEY" ]; then
  echo "⚠️  GEMINI_API_KEY not set. Set it using: export GEMINI_API_KEY=your-key"
  exit 1
fi

# Run FastAPI backend
echo "🚀 Starting FastAPI backend on http://localhost:8000"
# Get full path to current Python (inside venv)
PYTHON_PATH=$(which python)

# Start uvicorn using that exact Python path to avoid subprocess issues
"$PYTHON_PATH" -m uvicorn backend.main:app --reload &

# Wait for backend to initialize
sleep 2

# Run Streamlit frontend
echo "🌐 Launching Streamlit frontend on http://localhost:8501"
streamlit run frontend/app.py
