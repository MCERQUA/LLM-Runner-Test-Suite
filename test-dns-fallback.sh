#!/bin/bash

# Quick DNS Fallback Test
# Demonstrates the 4-tier DNS resolution system

echo "🧪 Testing DNS Resolution Fallback System"
echo "=========================================="

domain="api.llmrouter.dev"

echo "Testing domain: $domain"
echo ""

echo "1️⃣ Trying dig command..."
if result=$(dig +short $domain 2>/dev/null) && [[ -n "$result" ]]; then
    echo "✅ dig: $result"
    exit 0
fi
echo "❌ dig: not available or failed"

echo ""
echo "2️⃣ Trying host command..."
if result=$(host $domain 2>/dev/null) && [[ -n "$result" ]]; then
    echo "✅ host: $result"
    exit 0
fi
echo "❌ host: not available or failed"

echo ""
echo "3️⃣ Trying nslookup command..."
if result=$(nslookup $domain 2>/dev/null) && [[ -n "$result" ]]; then
    echo "✅ nslookup: Available"
    echo "$result" | grep -A1 "Name:" | tail -1
    exit 0
fi
echo "❌ nslookup: not available or failed"

echo ""
echo "4️⃣ Trying curl fallback..."
if curl -s --connect-timeout 5 --head $domain:443 >/dev/null 2>&1; then
    echo "✅ curl fallback: DNS Resolution: Success via curl"
    exit 0
fi
echo "❌ curl fallback: failed"

echo ""
echo "❌ All DNS resolution methods failed"
exit 1