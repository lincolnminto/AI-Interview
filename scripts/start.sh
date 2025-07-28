#!/bin/bash

# AI Interview System - Start Script
# This script starts both the Flask backend and React frontend

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEBAPP_DIR="$PROJECT_ROOT/WebApp"
APP_DIR="$PROJECT_ROOT/Application"

echo -e "${BLUE}🎤 AI Interview System - Starting...${NC}"
echo -e "${BLUE}============================================================${NC}"

# Check if ports are already in use
if lsof -ti:5000 >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port 5000 is already in use. Stopping existing Flask server...${NC}"
    lsof -ti:5000 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

if lsof -ti:3000 >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port 3000 is already in use. Stopping existing React server...${NC}"
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}🛑 Stopping servers...${NC}"
    # Kill Flask backend
    lsof -ti:5000 | xargs kill -9 2>/dev/null || true
    # Kill React frontend  
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    # Kill any remaining processes
    pkill -f "python3 app.py" 2>/dev/null || true
    pkill -f "react-scripts start" 2>/dev/null || true
    echo -e "${GREEN}✅ All servers stopped${NC}"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Export PATH for pip
export PATH=$PATH:/home/lincolnminto/.local/bin

echo -e "${BLUE}📂 Project Directory: $PROJECT_ROOT${NC}"

# Check if directories exist
if [ ! -d "$WEBAPP_DIR" ]; then
    echo -e "${RED}❌ WebApp directory not found: $WEBAPP_DIR${NC}"
    exit 1
fi

if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}❌ Application directory not found: $APP_DIR${NC}"
    exit 1
fi

# Start Flask Backend
echo -e "${BLUE}🐍 Starting Flask Backend...${NC}"
cd "$WEBAPP_DIR"

# Check if Python dependencies are installed
if ! python3 -c "import flask" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Flask not found. Installing dependencies...${NC}"
    pip3 install -r requirements.txt
fi

# Start Flask in background
echo -e "${GREEN}🚀 Starting Flask server on http://127.0.0.1:5000${NC}"
python3 app.py > flask.log 2>&1 &
FLASK_PID=$!

# Wait a moment for Flask to start
sleep 3

# Check if Flask started successfully
if ! kill -0 $FLASK_PID 2>/dev/null; then
    echo -e "${RED}❌ Flask failed to start. Check flask.log for errors${NC}"
    cat flask.log
    exit 1
fi

echo -e "${GREEN}✅ Flask backend started (PID: $FLASK_PID)${NC}"

# Start React Frontend
echo -e "${BLUE}⚛️  Starting React Frontend...${NC}"
cd "$APP_DIR"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}⚠️  Node modules not found. Installing dependencies...${NC}"
    npm install --legacy-peer-deps
fi

# Start React in background
echo -e "${GREEN}🚀 Starting React server on http://localhost:3000${NC}"
npm start > react.log 2>&1 &
REACT_PID=$!

# Wait a moment for React to start
sleep 5

# Check if React started successfully
if ! kill -0 $REACT_PID 2>/dev/null; then
    echo -e "${RED}❌ React failed to start. Check react.log for errors${NC}"
    cat react.log
    cleanup
    exit 1
fi

echo -e "${GREEN}✅ React frontend started (PID: $REACT_PID)${NC}"

# Save PIDs for stop script
echo "$FLASK_PID" > "$PROJECT_ROOT/scripts/.flask.pid"
echo "$REACT_PID" > "$PROJECT_ROOT/scripts/.react.pid"

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}🎉 AI Interview System is now running!${NC}"
echo -e "${GREEN}📱 Frontend: http://localhost:3000${NC}"
echo -e "${GREEN}🔧 Backend:  http://127.0.0.1:5000${NC}"
echo -e "${BLUE}============================================================${NC}"
echo -e "${YELLOW}💡 Press Ctrl+C to stop both servers${NC}"
echo -e "${YELLOW}💡 Or run: ./scripts/stop.sh to stop from another terminal${NC}"
echo -e "${BLUE}============================================================${NC}"

# Keep script running and wait for signal
wait