#!/bin/bash

echo "🔨 Building Swift project..."
swift build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    echo "🚀 Generating static site..."
    swift run
    
    if [ $? -eq 0 ]; then
        echo "✅ Site generated successfully!"
        
        echo "🧹 Checking for existing server on port 8000..."
        lsof -ti:8000 | xargs kill -9 2>/dev/null || true
        
        echo "🌐 Starting local server on http://localhost:8000"
        echo "Press Ctrl+C to stop the server"
        cd Output
        python3 -m http.server 8000
    else
        echo "❌ Failed to generate site"
        exit 1
    fi
else
    echo "❌ Build failed"
    exit 1
fi