#!/bin/bash

# 🧠 LLM Router Functional Test Runner
# Automatically loads environment and runs functional tests

set -e

echo "🧠 Loading environment and running LLM Router functional tests..."

# Load API key from .env file
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
    echo "✅ Loaded configuration from .env"
else
    echo "❌ No .env file found. Please create one with API_KEY set."
    exit 1
fi

# Set the API key for the functional tests
export ROUTER_API_KEY="$API_KEY"

echo "🚀 Starting functional tests against local server (http://localhost:3000)"
echo "🔑 Using API key: ${API_KEY:0:20}..."
echo ""

# Run the functional tests
./functional-llm-router-tests.sh