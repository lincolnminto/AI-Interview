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
    return "Rules page - ML functionality disabled in minimal mode"

############################### VIDEO INTERVIEW ################################

# Video interview template
@app.route('/video', methods=['POST'])
def video():
    flash('Video interview functionality disabled in minimal mode.')
    return render_template('video.html')

############################### AUDIO INTERVIEW ################################

# Audio interview template  
@app.route('/audio', methods=['POST'])
def audio():
    flash('Audio interview functionality disabled in minimal mode.')
    return render_template('audio.html')

if __name__ == '__main__':
    print("Starting minimal Flask app...")
    print("ML functionality disabled - install TensorFlow, OpenCV, librosa, and dlib for full functionality")
    app.run(debug=True, host='0.0.0.0', port=5000)