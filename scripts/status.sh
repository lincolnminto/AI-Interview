#!/bin/bash

# AI Interview System - Status Script
# This script checks the status of both Flask backend and React frontend

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"

echo -e "${BLUE}📊 AI Interview System - Status Check${NC}"
echo -e "${BLUE}============================================================${NC}"

# Check Flask Backend (Port 5000)
echo -e "${BLUE}🐍 Flask Backend Status:${NC}"
if lsof -ti:5000 >/dev/null 2>&1; then
    FLASK_PID=$(lsof -ti:5000)
    echo -e "${GREEN}  ✅ Running on port 5000 (PID: $FLASK_PID)${NC}"
    echo -e "${GREEN}  🌐 URL: http://127.0.0.1:5000${NC}"
    
    # Check if it's responding
    if curl -s http://127.0.0.1:5000 >/dev/null 2>&1; then
        echo -e "${GREEN}  ✅ Responding to requests${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Port is occupied but not responding${NC}"
    fi
else
    echo -e "${RED}  ❌ Not running${NC}"
fi

echo ""

# Check React Frontend (Port 3000)
echo -e "${BLUE}⚛️  React Frontend Status:${NC}"
if lsof -ti:3000 >/dev/null 2>&1; then
    REACT_PID=$(lsof -ti:3000)
    echo -e "${GREEN}  ✅ Running on port 3000 (PID: $REACT_PID)${NC}"
    echo -e "${GREEN}  🌐 URL: http://localhost:3000${NC}"
    
    # Check if it's responding
    if curl -s http://localhost:3000 >/dev/null 2>&1; then
        echo -e "${GREEN}  ✅ Responding to requests${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Port is occupied but not responding${NC}"
    fi
else
    echo -e "${RED}  ❌ Not running${NC}"
fi

echo ""

# Check PID files
echo -e "${BLUE}📁 PID Files Status:${NC}"
if [ -f "$SCRIPTS_DIR/.flask.pid" ]; then
    FLASK_PID_FILE=$(cat "$SCRIPTS_DIR/.flask.pid")
    if kill -0 "$FLASK_PID_FILE" 2>/dev/null; then
        echo -e "${GREEN}  ✅ Flask PID file valid (PID: $FLASK_PID_FILE)${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Flask PID file exists but process not running (stale)${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠️  No Flask PID file found${NC}"
fi

if [ -f "$SCRIPTS_DIR/.react.pid" ]; then
    REACT_PID_FILE=$(cat "$SCRIPTS_DIR/.react.pid")
    if kill -0 "$REACT_PID_FILE" 2>/dev/null; then
        echo -e "${GREEN}  ✅ React PID file valid (PID: $REACT_PID_FILE)${NC}"
    else
        echo -e "${YELLOW}  ⚠️  React PID file exists but process not running (stale)${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠️  No React PID file found${NC}"
fi

echo ""

# Check Python dependencies
echo -e "${BLUE}🐍 Python Dependencies:${NC}"
export PATH=$PATH:/home/lincolnminto/.local/bin

check_python_package() {
    local package=$1
    local import_name=$2
    if python3 -c "import $import_name" 2>/dev/null; then
        echo -e "${GREEN}  ✅ $package${NC}"
    else
        echo -e "${RED}  ❌ $package${NC}"
    fi
}

check_python_package "Flask" "flask"
check_python_package "TensorFlow" "tensorflow"
check_python_package "OpenCV" "cv2"
check_python_package "librosa" "librosa"
check_python_package "NumPy" "numpy"
check_python_package "Pandas" "pandas"

# Optional dependencies
echo -e "${BLUE}🔧 Optional Dependencies:${NC}"
check_python_package "dlib" "dlib"
check_python_package "PyAudio" "pyaudio"

echo ""

# Check Node.js dependencies
echo -e "${BLUE}⚛️  Node.js Dependencies:${NC}"
cd "$PROJECT_ROOT/Application"
if [ -d "node_modules" ]; then
    echo -e "${GREEN}  ✅ node_modules directory exists${NC}"
    if [ -f "package-lock.json" ]; then
        echo -e "${GREEN}  ✅ package-lock.json exists${NC}"
    else
        echo -e "${YELLOW}  ⚠️  package-lock.json missing${NC}"
    fi
else
    echo -e "${RED}  ❌ node_modules directory missing${NC}"
fi

echo ""
echo -e "${BLUE}============================================================${NC}"

# Overall status
FLASK_RUNNING=$(lsof -ti:5000 >/dev/null 2>&1 && echo "true" || echo "false")
REACT_RUNNING=$(lsof -ti:3000 >/dev/null 2>&1 && echo "true" || echo "false")

if [ "$FLASK_RUNNING" = "true" ] && [ "$REACT_RUNNING" = "true" ]; then
    echo -e "${GREEN}🎉 AI Interview System is fully operational!${NC}"
    echo -e "${GREEN}📱 Frontend: http://localhost:3000${NC}"
    echo -e "${GREEN}🔧 Backend:  http://127.0.0.1:5000${NC}"
elif [ "$FLASK_RUNNING" = "true" ] || [ "$REACT_RUNNING" = "true" ]; then
    echo -e "${YELLOW}⚠️  AI Interview System is partially running${NC}"
    echo -e "${YELLOW}💡 Run ./scripts/start.sh to start all services${NC}"
else
    echo -e "${RED}❌ AI Interview System is not running${NC}"
    echo -e "${BLUE}💡 Run ./scripts/start.sh to start the system${NC}"
fi

echo -e "${BLUE}============================================================${NC}"