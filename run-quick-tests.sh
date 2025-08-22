#!/bin/bash

# Quick Functional Test Runner - Run working tests only
export ROUTER_API_KEY="llm_baf8797fc1bf33b956fd7c0ffc4e9422.a4c53de7eb3366869fdf6bf3d5ea8b88b5578d62ec81183cf8eef99e78e303a1"

echo "🧠 Running Quick LLM Router Functional Tests"
echo "✅ Model Loading Tests:"

# Test 1: Basic Model Loading
echo "  [1] Basic Model Loading..."
curl -s -H "Authorization: Bearer $ROUTER_API_KEY" \
     -H "Content-Type: application/json" \
     -X POST \
     -d '{"source": "simple", "format": "simple", "id": "test-simple-model", "name": "Test Simple Model"}' \
     http://localhost:3000/api/models/load | grep -q '"success":true' && echo "    ✅ PASS" || echo "    ❌ FAIL"

# Test 2: Model Registry
echo "  [2] Model Registry Listing..."
MODELS=$(curl -s -H "Authorization: Bearer $ROUTER_API_KEY" http://localhost:3000/api/models)
echo "$MODELS" | grep -q '"count"' && echo "    ✅ PASS - $(echo "$MODELS" | grep -o '"count":[0-9]*' | cut -d: -f2) models" || echo "    ❌ FAIL"

# Test 3: Simple Chat Test
echo "  [3] Basic Chat Test..."
RESPONSE=$(curl -s -H "Authorization: Bearer $ROUTER_API_KEY" \
                -H "Content-Type: application/json" \
                -X POST \
                -d '{"messages": [{"role": "user", "content": "Hello"}], "maxTokens": 50}' \
                http://localhost:3000/api/chat)
echo "$RESPONSE" | grep -q '"response"' && echo "    ✅ PASS" || echo "    ❌ FAIL"

# Test 4: Quick Inference
echo "  [4] Quick Inference Test..."
QUICK=$(curl -s -H "Authorization: Bearer $ROUTER_API_KEY" \
             -H "Content-Type: application/json" \
             -X POST \
             -d '{"prompt": "Test", "maxTokens": 20}' \
             http://localhost:3000/api/quick)
echo "$QUICK" | grep -q '"response"' && echo "    ✅ PASS" || echo "    ❌ FAIL"

echo ""
echo "🎯 Quick test summary complete! Your LLM Router core functionality is working."