# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is an AI Interview System with emotion recognition capabilities consisting of two main components:

### Application (Frontend - React)
- **Location**: `Application/` directory
- **Tech Stack**: React 17, React Router, TailwindCSS
- **Purpose**: Client-side interface for conducting interviews
- **Key Components**:
  - Landing page for interview selection
  - Audio interview interface with `react-mic` for recording
  - Video interview interface with `react-video-recorder`
  - Routing between different interview types

### WebApp (Backend - Flask/Python)
- **Location**: `WebApp/` directory  
- **Tech Stack**: Flask, TensorFlow/Keras, OpenCV, librosa
- **Purpose**: Server-side emotion analysis and API endpoints
- **Key Modules**:
  - `library/speech_emotion_recognition.py` - Audio emotion analysis
  - `library/video_emotion_recognition.py` - Video/facial emotion analysis
  - Pre-trained models in `Models/` directory
  - Static assets and visualization tools in `static/`

The system processes both audio and video inputs to analyze emotions during mock interviews, providing feedback through data visualizations.

## Development Commands

### Frontend (Application/)
```bash
cd Application/
npm install          # Install dependencies
npm start           # Start development server (React)
npm run build       # Build for production
npm test            # Run Jest tests
```

### Backend (WebApp/)
```bash
cd WebApp/
pip install -r requirements.txt    # Install Python dependencies  
python app.py                      # Start Flask development server
```

### Docker Development
```bash
# From root directory
docker-compose build    # Build containers
docker-compose up       # Start both services

# From Application/ directory  
npm run dev            # Start with docker-compose.dev.yml
```

## Key Dependencies

### Frontend
- React Router v5 for client-side routing
- `react-mic` for audio recording functionality
- `react-video-recorder` for video capture
- TailwindCSS for styling

### Backend
- TensorFlow/Keras for ML models
- OpenCV for video processing
- librosa for audio analysis
- dlib for facial landmark detection
- Flask for web framework

## Important Notes

- The Flask app uses a hardcoded secret key that should be made configurable
- PyAudio installation may require platform-specific steps (see README)
- The system expects pre-trained models in `WebApp/Models/`
- Video processing requires `face_landmarks.dat` file for dlib
- Audio analysis depends on proper microphone permissions in browser