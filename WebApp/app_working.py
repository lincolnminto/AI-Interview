### General imports ###
from __future__ import division
import numpy as np
import pandas as pd
import time
import re
import os
from collections import Counter
import altair as alt

### Flask imports
import requests
from flask import Flask, render_template, session, request, redirect, flash, Response

# Try to import ML libraries, fallback gracefully if missing
try:
    import tensorflow as tf
    import cv2  # opencv-python
    import librosa
    TF_AVAILABLE = True
    print("✅ TensorFlow, OpenCV, and librosa are available!")
except ImportError as e:
    TF_AVAILABLE = False
    print(f"⚠️  ML libraries not available: {e}")

# Try to import dlib and pyaudio, fallback if missing
try:
    import dlib
    DLIB_AVAILABLE = True
    print("✅ dlib is available!")
except ImportError:
    DLIB_AVAILABLE = False
    print("⚠️  dlib not available - facial recognition disabled")

try:
    import pyaudio
    PYAUDIO_AVAILABLE = True
    print("✅ PyAudio is available!")
except ImportError:
    PYAUDIO_AVAILABLE = False
    print("⚠️  PyAudio not available - real-time audio disabled")

# Flask config
app = Flask(__name__)
app.secret_key = b'(\xee\x00\xd4\xce"\xcf\xe8@\r\xde\xfc\xbdJ\x08W'
app.config['UPLOAD_FOLDER'] = '/Upload'

################################## INDEX #######################################

# Home page
@app.route('/', methods=['GET'])
def index():
    return render_template('landing.html')

################################## RULES #######################################

# Rules of the game
@app.route('/rules')
def rules():
    return "Rules page"

############################### VIDEO INTERVIEW ################################

# Read the overall dataframe before the user starts to add his own data
try:
    df = pd.read_csv('static/js/db/histo.txt', sep=",")
except FileNotFoundError:
    df = pd.DataFrame()  # Empty dataframe fallback

# Video interview template
@app.route('/video', methods=['POST'])
def video():
    if not TF_AVAILABLE or not DLIB_AVAILABLE:
        flash('Video analysis requires TensorFlow and dlib. Currently running in demo mode.')
    else:
        flash('You will have 45 seconds to discuss the topic mentioned above.')
    return render_template('video.html')

############################### AUDIO INTERVIEW ################################

# Audio interview template  
@app.route('/audio', methods=['POST'])
def audio():
    if not TF_AVAILABLE or not PYAUDIO_AVAILABLE:
        flash('Audio analysis requires TensorFlow and PyAudio. Currently running in demo mode.')
    else:
        flash('Audio interview ready!')
    return render_template('audio.html')

############################### API ENDPOINTS ################################

@app.route('/video_dash')
def video_dash():
    """Video analysis results dashboard"""
    if TF_AVAILABLE and DLIB_AVAILABLE:
        # TODO: Implement actual video analysis
        return "Video analysis results (placeholder - ML functionality available)"
    else:
        return "Video analysis not available - missing dependencies (dlib, TensorFlow)"

@app.route('/audio_dash') 
def audio_dash():
    """Audio analysis results dashboard"""
    if TF_AVAILABLE:
        # TODO: Implement actual audio analysis  
        return "Audio analysis results (placeholder - ML functionality available)"
    else:
        return "Audio analysis not available - missing dependencies"

if __name__ == '__main__':
    print("\n" + "="*60)
    print("🎤 AI Interview System Starting...")
    print("="*60)
    
    # Status check
    status = []
    if TF_AVAILABLE:
        status.append("✅ TensorFlow: Available")
    else:
        status.append("❌ TensorFlow: Missing")
        
    if DLIB_AVAILABLE:
        status.append("✅ dlib: Available") 
    else:
        status.append("❌ dlib: Missing (facial recognition disabled)")
        
    if PYAUDIO_AVAILABLE:
        status.append("✅ PyAudio: Available")
    else:
        status.append("❌ PyAudio: Missing (real-time audio disabled)")
    
    for s in status:
        print(s)
    
    print("="*60)
    print("🚀 Starting server on http://127.0.0.1:5000")
    print("🌐 Frontend available on http://localhost:3000")
    print("="*60)
    
    app.run(debug=True, host='0.0.0.0', port=5000)