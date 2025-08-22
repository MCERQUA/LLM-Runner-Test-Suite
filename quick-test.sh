#!/bin/bash

# LLM Router API - Quick Test Script
# Minimal test for immediate validation

set -euo pipefail

# Configuration
BASE_URL="${BASE_URL:-https://api.llmrouter.dev}"
DOCS_URL="${DOCS_URL:-https://llmrouter.dev}"
API_KEY="${API_KEY:-}"

# Load .env if exists
if [[ -f ".env" ]]; then
    source .env
fi

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 LLM Router API - Quick Test${NC}"
echo "================================"
echo ""

# Test 1: Health Check
echo -n "🔍 Testing health endpoint... "
if health_response=$(curl -s --connect-timeout 10 "$BASE_URL/api/health" 2>/dev/null); then
    if echo "$health_response" | grep -q '"status":"healthy"'; then
        echo -e "${GREEN}✅ HEALTHY${NC}"
        echo "   Response: $(echo "$health_response" | jq -c '.')"
    else
        echo -e "${YELLOW}⚠️  UNEXPECTED RESPONSE${NC}"
        echo "   Response: $health_response"
    fi
else
    echo -e "${RED}❌ FAILED${NC}"
    echo "   Could not connect to $BASE_URL"
fi

echo ""

# Test 2: Documentation
echo -n "📚 Testing documentation site... "
if docs_status=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$DOCS_URL" 2>/dev/null); then
    if [[ "$docs_status" == "200" ]]; then
        echo -e "${GREEN}✅ ACCESSIBLE${NC}"
        echo "   Status: HTTP $docs_status"
    else
        echo -e "${YELLOW}⚠️  STATUS: HTTP $docs_status${NC}"
    fi
else
    echo -e "${RED}❌ FAILED${NC}"
    echo "   Could not connect to $DOCS_URL"
fi

echo ""

# Test 3: API Key Test (if provided)
if [[ -n "$API_KEY" ]] && [[ "$API_KEY" != "your-api-key-here" ]]; then
    echo -n "🔐 Testing protected endpoint... "
    if models_response=$(curl -s --connect-timeout 10 -H "X-API-Key: $API_KEY" "$BASE_URL/api/models" 2>/dev/null); then
        if echo "$models_response" | grep -q "models\|error"; then
            echo -e "${GREEN}✅ RESPONDING${NC}"
            echo "   API key: ${API_KEY:0:8}..."
        else
            echo -e "${YELLOW}⚠️  UNEXPECTED RESPONSE${NC}"
            echo "   Response: $models_response"
        fi
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "   Protected endpoint test failed"
    fi
else
    echo -e "${YELLOW}⚠️  No API key configured - skipping protected endpoint test${NC}"
    echo "   Set API_KEY in .env file to test protected endpoints"
fi

echo ""

# Test 4: Response Time
echo -n "⚡ Measuring response time... "
start_time=$(date +%s%N)
curl -s --connect-timeout 10 "$BASE_URL/api/health" > /dev/null 2>&1
end_time=$(date +%s%N)
response_time=$(( (end_time - start_time) / 1000000 ))

if [[ $response_time -lt 500 ]]; then
    echo -e "${GREEN}✅ FAST (${response_time}ms)${NC}"
elif [[ $response_time -lt 1000 ]]; then
    echo -e "${YELLOW}⚡ GOOD (${response_time}ms)${NC}"
else
    echo -e "${YELLOW}⚠️  SLOW (${response_time}ms)${NC}"
fi

echo ""
echo "🎯 Quick test complete!"
echo "💡 For comprehensive testing, run: ./test-suite.sh"
echo ""