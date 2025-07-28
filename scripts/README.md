# AI Interview System - Scripts

This directory contains utility scripts to manage the AI Interview System.

## Available Scripts

### 🚀 `start.sh` - Start the System
Starts both Flask backend and React frontend servers.

```bash
./scripts/start.sh
```

**Features:**
- ✅ Automatically checks and kills existing processes on ports 3000/5000
- ✅ Installs missing dependencies if needed
- ✅ Starts Flask backend on http://127.0.0.1:5000
- ✅ Starts React frontend on http://localhost:3000
- ✅ Handles graceful shutdown with Ctrl+C
- ✅ Creates PID files for process management
- ✅ Colored output for better readability

### 🛑 `stop.sh` - Stop the System
Stops all running AI Interview System processes.

```bash
./scripts/stop.sh
```

**Features:**
- ✅ Gracefully stops processes using PID files
- ✅ Force kills if graceful shutdown fails
- ✅ Cleans up ports 3000 and 5000
- ✅ Removes PID files and log files
- ✅ Fallback cleanup by process name

### 📊 `status.sh` - Check System Status
Shows the current status of all components.

```bash
./scripts/status.sh
```

**Features:**
- ✅ Checks if Flask backend is running (port 5000)
- ✅ Checks if React frontend is running (port 3000)
- ✅ Validates PID files
- ✅ Tests if services are responding
- ✅ Checks Python dependencies
- ✅ Checks Node.js dependencies
- ✅ Overall system status summary

## Usage Examples

### Start the system:
```bash
cd /home/lincolnminto/Projects/AI-Interview
./scripts/start.sh
```

### Check if everything is running:
```bash
./scripts/status.sh
```

### Stop the system:
```bash
./scripts/stop.sh
```

### Restart the system:
```bash
./scripts/stop.sh && ./scripts/start.sh
```

## File Locations

- **Scripts**: `/home/lincolnminto/Projects/AI-Interview/scripts/`
- **Flask Logs**: `/home/lincolnminto/Projects/AI-Interview/WebApp/flask.log`
- **React Logs**: `/home/lincolnminto/Projects/AI-Interview/Application/react.log`
- **PID Files**: `/home/lincolnminto/Projects/AI-Interview/scripts/.flask.pid` & `.react.pid`

## Troubleshooting

### If ports are still occupied:
```bash
# Kill processes manually
lsof -ti:3000 | xargs kill -9
lsof -ti:5000 | xargs kill -9
```

### If dependencies are missing:
```bash
# For Python dependencies
cd WebApp && pip3 install -r requirements.txt

# For Node.js dependencies  
cd Application && npm install --legacy-peer-deps
```

### View logs:
```bash
# Flask logs
tail -f WebApp/flask.log

# React logs
tail -f Application/react.log
```

## Script Features

- 🎨 **Colored Output**: Easy to read status messages
- 🔧 **Error Handling**: Robust error handling and cleanup
- 📊 **Status Monitoring**: Comprehensive system health checks
- 🚀 **Auto-Recovery**: Automatically handles common issues
- 🧹 **Clean Shutdown**: Proper cleanup of processes and files