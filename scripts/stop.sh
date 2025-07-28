#!/bin/bash

# AI Interview System - Stop Script
# This script stops both the Flask backend and React frontend

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

echo -e "${BLUE}🛑 AI Interview System - Stopping...${NC}"
echo -e "${BLUE}============================================================${NC}"

# Function to stop process by PID
stop_process_by_pid() {
    local pid_file=$1
    local name=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo -e "${YELLOW}🔄 Stopping $name (PID: $pid)...${NC}"
            kill -TERM "$pid" 2>/dev/null || true
            
            # Wait up to 10 seconds for graceful shutdown
            local count=0
            while kill -0 "$pid" 2>/dev/null && [ $count -lt 10 ]; do
                sleep 1
                count=$((count + 1))
            done
            
            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                echo -e "${YELLOW}⚠️  Force killing $name...${NC}"
                kill -KILL "$pid" 2>/dev/null || true
            fi
            
            echo -e "${GREEN}✅ $name stopped${NC}"
        else
            echo -e "${YELLOW}⚠️  $name was not running (stale PID file)${NC}"
        fi
        rm -f "$pid_file"
    else
        echo -e "${YELLOW}⚠️  No PID file found for $name${NC}"
    fi
}

# Stop processes using PID files
stop_process_by_pid "$SCRIPTS_DIR/.flask.pid" "Flask Backend"
stop_process_by_pid "$SCRIPTS_DIR/.react.pid" "React Frontend"

# Additional cleanup - stop by port
echo -e "${BLUE}🔍 Checking for remaining processes on ports 3000 and 5000...${NC}"

# Stop Flask (port 5000)
if lsof -ti:5000 >/dev/null 2>&1; then
    echo -e "${YELLOW}🔄 Stopping remaining processes on port 5000...${NC}"
    lsof -ti:5000 | xargs kill -9 2>/dev/null || true
    echo -e "${GREEN}✅ Port 5000 cleared${NC}"
else
    echo -e "${GREEN}✅ Port 5000 is free${NC}"
fi

# Stop React (port 3000)
if lsof -ti:3000 >/dev/null 2>&1; then
    echo -e "${YELLOW}🔄 Stopping remaining processes on port 3000...${NC}"
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    echo -e "${GREEN}✅ Port 3000 cleared${NC}"
else
    echo -e "${GREEN}✅ Port 3000 is free${NC}"
fi

# Stop processes by name (fallback)
echo -e "${BLUE}🔍 Stopping any remaining AI Interview processes...${NC}"

# Stop Flask processes
if pkill -f "python3 app.py" 2>/dev/null; then
    echo -e "${GREEN}✅ Stopped Flask processes${NC}"
fi

# Stop React processes
if pkill -f "react-scripts start" 2>/dev/null; then
    echo -e "${GREEN}✅ Stopped React processes${NC}"
fi

# Stop npm processes related to the project
if pkill -f "npm start" 2>/dev/null; then
    echo -e "${GREEN}✅ Stopped npm processes${NC}"
fi

# Clean up log files
echo -e "${BLUE}🧹 Cleaning up log files...${NC}"
rm -f "$PROJECT_ROOT/WebApp/flask.log"
rm -f "$PROJECT_ROOT/Application/react.log"

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}🎉 AI Interview System stopped successfully!${NC}"
echo -e "${BLUE}============================================================${NC}"

# Verify ports are free
sleep 1
if ! lsof -ti:3000 >/dev/null 2>&1 && ! lsof -ti:5000 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ All ports are now free${NC}"
else
    echo -e "${YELLOW}⚠️  Some ports may still be in use. Try running the script again.${NC}"
fi