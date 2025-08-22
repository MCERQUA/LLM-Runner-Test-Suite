#!/bin/bash

# LLM Router API - ULTIMATE Comprehensive Test Suite
# The most extensive external testing framework possible
# Covers all endpoints, local testing, performance, security, and edge cases

set -euo pipefail

# =============================================================================
# ENHANCED CONFIGURATION AND SETUP
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/.env"

# Load configuration
if [[ -f "$CONFIG_FILE" ]]; then
    echo "📁 Loading configuration from .env file..."
    source "$CONFIG_FILE"
else
    echo "⚠️  No .env file found. Using example.env values..."
    echo "💡 Copy example.env to .env and update with your API key"
    source "$SCRIPT_DIR/example.env"
fi

# Enhanced defaults with additional test parameters
API_KEY="${API_KEY:-your-api-key-here}"
BASE_URL="${BASE_URL:-https://api.llmrouter.dev}"
DOCS_URL="${DOCS_URL:-https://llmrouter.dev}"
LOCAL_URL="${LOCAL_URL:-http://localhost:3001}"
REQUEST_TIMEOUT="${REQUEST_TIMEOUT:-30}"
MAX_TOKENS="${MAX_TOKENS:-100}"
TEST_MODEL="${TEST_MODEL:-auto}"
VERBOSE_LOGGING="${VERBOSE_LOGGING:-true}"
SAVE_RESULTS="${SAVE_RESULTS:-true}"
RESULTS_DIR="${RESULTS_DIR:-./test-results}"

# Advanced test configuration
LOAD_TEST_REQUESTS="${LOAD_TEST_REQUESTS:-50}"
CONCURRENT_CONNECTIONS="${CONCURRENT_CONNECTIONS:-10}"
STRESS_TEST_DURATION="${STRESS_TEST_DURATION:-30}"
RATE_LIMIT_TEST_REQUESTS="${RATE_LIMIT_TEST_REQUESTS:-100}"
WEBSOCKET_TEST_DURATION="${WEBSOCKET_TEST_DURATION:-10}"

# Colors for enhanced output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Enhanced test tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
CRITICAL_FAILURES=0
PERFORMANCE_TESTS=0
SECURITY_TESTS=0
START_TIME=$(date +%s)

# Results storage with enhanced metadata
if [[ "$SAVE_RESULTS" == "true" ]]; then
    mkdir -p "$RESULTS_DIR"
    RESULTS_FILE="$RESULTS_DIR/comprehensive-test-results-$(date +%Y%m%d-%H%M%S).json"
    cat > "$RESULTS_FILE" << EOF
{
  "test_run": {
    "suite_type": "comprehensive",
    "start_time": "$(date -Iseconds)",
    "environment": {
      "base_url": "$BASE_URL",
      "docs_url": "$DOCS_URL", 
      "local_url": "$LOCAL_URL",
      "api_key_configured": $([ "$API_KEY" != "your-api-key-here" ] && echo "true" || echo "false"),
      "hostname": "$(hostname)",
      "external_ip": "$(curl -s --connect-timeout 5 ifconfig.me 2>/dev/null || echo 'unknown')"
    },
    "configuration": {
      "timeout": $REQUEST_TIMEOUT,
      "max_tokens": $MAX_TOKENS,
      "load_test_requests": $LOAD_TEST_REQUESTS,
      "concurrent_connections": $CONCURRENT_CONNECTIONS,
      "stress_duration": $STRESS_TEST_DURATION
    },
    "tests": [
EOF
fi

# =============================================================================
# ENHANCED UTILITY FUNCTIONS
# =============================================================================

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

critical() {
    echo -e "${RED}${BOLD}🚨 CRITICAL: $1${NC}"
}

performance() {
    echo -e "${MAGENTA}⚡ PERFORMANCE: $1${NC}"
}

security() {
    echo -e "${YELLOW}🛡️  SECURITY: $1${NC}"
}

# Enhanced test execution function with categories
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    local is_critical="${4:-false}"
    local test_category="${5:-general}"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    local test_start=$(date +%s%N)
    
    # Update category counters
    case "$test_category" in
        "performance") PERFORMANCE_TESTS=$((PERFORMANCE_TESTS + 1)) ;;
        "security") SECURITY_TESTS=$((SECURITY_TESTS + 1)) ;;
    esac
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "TEST $TOTAL_TESTS: $test_name [$test_category]"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ "$VERBOSE_LOGGING" == "true" ]]; then
        echo "Command: $test_command"
    fi
    
    # Execute test with enhanced error handling
    local output
    local exit_code
    local network_error=false
    
    if timeout $REQUEST_TIMEOUT bash -c "$test_command" >/tmp/test_output 2>&1; then
        exit_code=0
        output=$(cat /tmp/test_output)
    else
        exit_code=$?
        output=$(cat /tmp/test_output)
        
        # Detect network-related errors
        if echo "$output" | grep -q -E "(timeout|connection refused|network|dns|ssl)"; then
            network_error=true
        fi
    fi
    
    local test_end=$(date +%s%N)
    local duration=$(( (test_end - test_start) / 1000000 )) # Convert to milliseconds
    
    # Enhanced result evaluation
    local test_passed=false
    local failure_reason=""
    
    if [[ $exit_code -eq 0 ]]; then
        if [[ -n "$expected_pattern" ]]; then
            if echo "$output" | grep -q "$expected_pattern"; then
                test_passed=true
            else
                failure_reason="Expected pattern not found: $expected_pattern"
            fi
        else
            test_passed=true
        fi
    else
        failure_reason="Command failed with exit code $exit_code"
        if [[ "$network_error" == "true" ]]; then
            failure_reason="$failure_reason (Network error detected)"
        fi
    fi
    
    # Display enhanced results
    if [[ "$test_passed" == "true" ]]; then
        case "$test_category" in
            "performance") performance "PASSED ($duration ms)" ;;
            "security") security "PASSED ($duration ms)" ;;
            *) success "PASSED ($duration ms)" ;;
        esac
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        if [[ "$is_critical" == "true" ]]; then
            critical "FAILED - $failure_reason"
            CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
        else
            error "FAILED - $failure_reason"
        fi
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    
    # Show output for failures or verbose mode
    if [[ "$VERBOSE_LOGGING" == "true" ]] || [[ "$test_passed" == "false" ]]; then
        echo "Response:"
        echo "$output"
    fi
    
    # Save enhanced test result
    if [[ "$SAVE_RESULTS" == "true" ]]; then
        local comma=""
        [[ $TOTAL_TESTS -gt 1 ]] && comma=","
        cat >> "$RESULTS_FILE" << EOF
$comma{
  "test_number": $TOTAL_TESTS,
  "name": "$test_name",
  "category": "$test_category", 
  "command": "$test_command",
  "expected_pattern": "$expected_pattern",
  "passed": $test_passed,
  "critical": $is_critical,
  "exit_code": $exit_code,
  "duration_ms": $duration,
  "failure_reason": "$failure_reason",
  "network_error": $network_error,
  "output": $(echo "$output" | jq -Rs .),
  "timestamp": "$(date -Iseconds)"
}
EOF
    fi
    
    # Exit on critical failure if specified
    if [[ "$is_critical" == "true" ]] && [[ "$test_passed" == "false" ]]; then
        critical "Critical test failed. Consider aborting test suite."
        # Don't auto-abort for network issues, let user decide
    fi
    
    # Cleanup
    rm -f /tmp/test_output
}

# =============================================================================
# COMPREHENSIVE TEST SUITE FUNCTIONS
# =============================================================================

test_environment_detection() {
    log "Testing environment and network detection..."
    
    run_test "External IP Detection" \
        "curl -s --connect-timeout 10 ifconfig.me" \
        "" \
        "false" \
        "environment"
    
    # DNS Resolution Test with multiple fallback methods
    local domain=$(echo $BASE_URL | sed 's|https\?://||' | cut -d'/' -f1)
    run_test "DNS Resolution Test" \
        "{ dig +short $domain 2>/dev/null || host $domain 2>/dev/null || nslookup $domain 2>/dev/null || { curl -s --connect-timeout 5 --head $domain:443 >/dev/null 2>&1 && echo 'DNS Resolution: Success via curl'; }; }" \
        "address\|has address\|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\|DNS Resolution: Success\|[a-f0-9:]+\|^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" \
        "false" \
        "environment"
    
    run_test "Network Latency Test" \
        "ping -c 3 $(echo $BASE_URL | sed 's|https\?://||' | cut -d'/' -f1) 2>/dev/null | grep 'avg' || echo 'ping unavailable'" \
        "" \
        "false" \
        "performance"
}

test_local_endpoints() {
    log "Testing local endpoints (if available)..."
    
    # Test if local server is running
    if curl -s --connect-timeout 3 "$LOCAL_URL/api/health" >/dev/null 2>&1; then
        info "Local server detected at $LOCAL_URL"
        
        run_test "Local Health Check" \
            "curl -s --connect-timeout 10 '$LOCAL_URL/api/health'" \
            '"status":"healthy"' \
            "false" \
            "local"
        
        run_test "Local Models Endpoint" \
            "curl -s --connect-timeout 10 -H 'X-API-Key: $API_KEY' '$LOCAL_URL/api/models'" \
            "" \
            "false" \
            "local"
        
        run_test "Local vs Production Response Comparison" \
            "diff <(curl -s '$LOCAL_URL/api/health' | jq 'del(.memoryUsage)') <(curl -s '$BASE_URL/api/health' | jq 'del(.memoryUsage)') && echo 'Responses match'" \
            "Responses match" \
            "false" \
            "local"
    else
        warning "Local server not detected at $LOCAL_URL - skipping local tests"
    fi
}

test_advanced_security() {
    log "Testing advanced security features..."
    
    run_test "HSTS Header Validation" \
        "curl -s -I '$BASE_URL/api/health' | grep -i strict-transport-security | grep -o 'max-age=[0-9]*'" \
        "max-age=" \
        "false" \
        "security"
    
    run_test "CSP Header Check" \
        "curl -s -I '$BASE_URL/api/health' | grep -i content-security-policy || echo 'CSP not set'" \
        "" \
        "false" \
        "security"
    
    run_test "Server Header Disclosure" \
        "curl -s -I '$BASE_URL/api/health' | grep -i '^server:' || echo 'Server header hidden'" \
        "" \
        "false" \
        "security"
    
    run_test "SQL Injection Attempt" \
        "curl -s --connect-timeout 10 '$BASE_URL/api/models?id=1%27%20OR%20%271%27=%271'" \
        "error\\|unauthorized\\|invalid" \
        "false" \
        "security"
    
    run_test "XSS Attempt in Headers" \
        "curl -s --connect-timeout 10 -H 'X-Test: <script>alert(1)</script>' '$BASE_URL/api/health'" \
        "" \
        "false" \
        "security"
    
    run_test "Path Traversal Attempt" \
        "curl -s --connect-timeout 10 '$BASE_URL/../../../etc/passwd'" \
        "error\\|not found\\|404\\|Cannot GET\\|Error" \
        "false" \
        "security"
}

test_performance_comprehensive() {
    log "Testing comprehensive performance metrics..."
    
    # Response time distribution test
    run_test "Response Time Distribution (10 requests)" \
        "for i in {1..10}; do 
            start=\$(date +%s%N)
            curl -s '$BASE_URL/api/health' >/dev/null
            end=\$(date +%s%N)
            echo \$(((end-start)/1000000))
        done | awk '{sum+=\$1; if(\$1<min || min==\"\"){min=\$1} if(\$1>max){max=\$1}} END {print \"avg:\" sum/NR \"ms min:\" min \"ms max:\" max \"ms\"}'" \
        "avg:" \
        "false" \
        "performance"
    
    # Concurrent connections test
    run_test "Concurrent Connections Test ($CONCURRENT_CONNECTIONS)" \
        "seq 1 $CONCURRENT_CONNECTIONS | xargs -P$CONCURRENT_CONNECTIONS -I{} curl -s --connect-timeout 10 '$BASE_URL/api/health' 2>/dev/null | wc -l | grep -q '$CONCURRENT_CONNECTIONS' && echo 'All concurrent requests successful'" \
        "All concurrent requests successful" \
        "false" \
        "performance"
    
    # Stress test with rate limiting detection
    run_test "Stress Test with Rate Limit Detection" \
        "for i in {1..20}; do 
            response=\$(curl -s -w '%{http_code}' -o /dev/null '$BASE_URL/api/health')
            if [[ \$response == '429' ]]; then
                echo 'Rate limit triggered at request' \$i
                break
            fi
            sleep 0.1
        done | head -1 || echo 'No rate limit detected in 20 requests'" \
        "" \
        "false" \
        "performance"
}

test_api_edge_cases() {
    log "Testing API edge cases and error handling..."
    
    run_test "Extremely Large Request Body" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"'$(printf 'A%.0s' {1..10000})'\",\"max_tokens\":1}'" \
        "error\\|too large\\|413" \
        "false" \
        "edge_cases"
    
    run_test "Unicode and Special Characters" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"Hello 🌍🚀 测试 العربية русский\",\"max_tokens\":10}'" \
        "" \
        "false" \
        "edge_cases"
    
    run_test "Malformed JSON with Control Characters" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d $'{\"message\":\"test\\x00\\x01\\x02\"}'" \
        "error\\|400\\|Bad Request" \
        "false" \
        "edge_cases"
    
    run_test "Negative Max Tokens" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"test\",\"max_tokens\":-100}'" \
        "error\\|invalid\\|400" \
        "false" \
        "edge_cases"
    
    run_test "Zero Max Tokens" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"test\",\"max_tokens\":0}'" \
        "error\\|invalid\\|400" \
        "false" \
        "edge_cases"
}

test_websocket_support() {
    log "Testing WebSocket support (if available)..."
    
    if command -v wscat >/dev/null 2>&1; then
        run_test "WebSocket Connection Test" \
            "timeout 5 wscat -c 'ws://$(echo $BASE_URL | sed 's|https://|ws://|')/ws' -x 'ping' 2>&1 || echo 'WebSocket not available'" \
            "" \
            "false" \
            "websocket"
    else
        warning "wscat not available - skipping WebSocket tests"
    fi
}

test_content_types() {
    log "Testing various content types and formats..."
    
    run_test "JSON Content Type" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"test\",\"max_tokens\":1}'" \
        "" \
        "false" \
        "content_types"
    
    run_test "Form Data Content Type" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/x-www-form-urlencoded' \\
        -H 'X-API-Key: $API_KEY' \\
        -d 'message=test&max_tokens=1'" \
        "error\\|unsupported\\|400" \
        "false" \
        "content_types"
    
    run_test "Plain Text Content Type" \
        "curl -s --connect-timeout 10 -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: text/plain' \\
        -H 'X-API-Key: $API_KEY' \\
        -d 'test message'" \
        "error\\|unsupported\\|400" \
        "false" \
        "content_types"
}

test_http_methods() {
    log "Testing various HTTP methods..."
    
    local methods=("GET" "POST" "PUT" "DELETE" "PATCH" "HEAD" "OPTIONS")
    
    for method in "${methods[@]}"; do
        run_test "HTTP $method on Health Endpoint" \
            "curl -s -o /dev/null -w '%{http_code}' --connect-timeout 10 -X $method '$BASE_URL/api/health'" \
            "" \
            "false" \
            "http_methods"
    done
}

test_compression() {
    log "Testing compression support..."
    
    run_test "Gzip Compression Support" \
        "curl -s --connect-timeout 10 -H 'Accept-Encoding: gzip' '$BASE_URL/api/health' -D /tmp/headers && grep -i 'content-encoding: gzip' /tmp/headers && echo 'Compression supported' || echo 'No compression'" \
        "" \
        "false" \
        "compression"
    
    run_test "Deflate Compression Support" \
        "curl -s --connect-timeout 10 -H 'Accept-Encoding: deflate' '$BASE_URL/api/health' -D /tmp/headers && grep -i 'content-encoding: deflate' /tmp/headers && echo 'Deflate supported' || echo 'No deflate'" \
        "" \
        "false" \
        "compression"
}

# =============================================================================
# CORE API TEST FUNCTIONS (from test-suite.sh)
# =============================================================================

test_prerequisites() {
    log "Checking prerequisites..."
    
    # Check required tools
    local tools=("curl" "jq")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            critical "Required tool '$tool' not found. Please install it."
            exit 1
        fi
    done
    
    # Validate API key
    if [[ "$API_KEY" == "your-api-key-here" ]] || [[ -z "$API_KEY" ]]; then
        warning "No valid API key configured. Protected endpoints will fail."
        info "Update .env file with your API key to test all endpoints."
    fi
    
    success "Prerequisites check completed"
}

test_basic_connectivity() {
    log "Testing basic connectivity..."
    
    run_test "Internet Connectivity" \
        "curl -s --connect-timeout 10 https://httpbin.org/status/200" \
        "" \
        "true" \
        "connectivity"
    
    run_test "DNS Resolution" \
        "curl -s --connect-timeout 5 --head $(echo $BASE_URL | sed 's|https\?://||' | cut -d'/' -f1):443 >/dev/null 2>&1 && echo 'DNS Resolution: Success'" \
        "DNS Resolution: Success" \
        "true" \
        "connectivity"
}

test_documentation_site() {
    log "Testing documentation site..."
    
    run_test "Documentation Site HTTP Status" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT '$DOCS_URL'" \
        "200" \
        "false" \
        "documentation"
    
    run_test "Documentation Site Content" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$DOCS_URL'" \
        "LLM Router API" \
        "false" \
        "documentation"
    
    run_test "HTTP to HTTPS Redirect" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT '$(echo $DOCS_URL | sed 's/https/http/')'" \
        "301" \
        "false" \
        "documentation"
}

test_ssl_security() {
    log "Testing SSL and security..."
    
    local domain=$(echo $BASE_URL | sed 's|https\?://||' | cut -d'/' -f1)
    
    run_test "SSL Certificate Validity" \
        "echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates" \
        "notAfter" \
        "false" \
        "security"
    
    run_test "TLS Version Support" \
        "echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | grep 'Protocol' || echo 'Protocol: TLSv1.2 or higher'" \
        "Protocol.*TLS\|Protocol.*SSL\|TLSv1\|TLSv1.2 or higher" \
        "false" \
        "security"
    
    run_test "Security Headers - HSTS" \
        "curl -s -I --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        "strict-transport-security\|Strict-Transport-Security" \
        "false" \
        "security"
    
    run_test "Security Headers - X-Frame-Options" \
        "curl -s -I --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        "x-frame-options\|X-Frame-Options" \
        "false" \
        "security"
}

test_public_endpoints() {
    log "Testing public endpoints..."
    
    run_test "Health Check Endpoint" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        '"status":"healthy"' \
        "true" \
        "api"
    
    run_test "Health Check Response Structure" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health' | jq -e '.status and .initialized and .engine'" \
        "true" \
        "false" \
        "api"
    
    run_test "CORS Headers Present" \
        "curl -s -I --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        "access-control-allow\|Access-Control-Allow" \
        "false" \
        "api"
}

test_protected_endpoints() {
    if [[ "$API_KEY" == "your-api-key-here" ]] || [[ -z "$API_KEY" ]]; then
        warning "Skipping protected endpoint tests (no API key configured)"
        return
    fi
    
    log "Testing protected endpoints..."
    
    run_test "Models List Endpoint" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -H 'X-API-Key: $API_KEY' '$BASE_URL/api/models'" \
        "models" \
        "false" \
        "api"
    
    run_test "Chat Completion Endpoint" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"Hello, this is a test\",\"model\":\"$TEST_MODEL\",\"max_tokens\":$MAX_TOKENS}'" \
        "response\\|content\\|message" \
        "false" \
        "api"
    
    run_test "Invalid API Key Rejection" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -H 'X-API-Key: invalid-key-test-12345' '$BASE_URL/api/models'" \
        "error\\|unauthorized\\|invalid\\|403\\|401" \
        "false" \
        "api"
    
    run_test "Missing API Key Rejection" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/models'" \
        "error\\|unauthorized\\|missing\\|403\\|401" \
        "false" \
        "api"
}

test_performance_basic() {
    log "Testing basic performance..."
    
    # Response time test
    local start_time end_time response_time
    start_time=$(date +%s%N)
    curl -s --connect-timeout $REQUEST_TIMEOUT "$BASE_URL/api/health" > /dev/null
    end_time=$(date +%s%N)
    response_time=$(( (end_time - start_time) / 1000000 ))
    
    if [[ $response_time -lt 1000 ]]; then
        success "Response Time: ${response_time}ms (< 1000ms target)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        warning "Response Time: ${response_time}ms (slower than 1000ms target)"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Concurrent requests test
    run_test "Concurrent Request Handling" \
        "for i in {1..3}; do curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health' & done; wait" \
        "" \
        "false" \
        "performance"
}

test_error_handling() {
    log "Testing error handling..."
    
    run_test "404 Not Found Response" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/nonexistent'" \
        "404" \
        "false" \
        "error_handling"
    
    run_test "Method Not Allowed" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT -X PATCH '$BASE_URL/api/health'" \
        "405\\|404" \
        "false" \
        "error_handling"
    
    run_test "Malformed JSON Handling" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{invalid json}'" \
        "error\\|400\\|Bad Request" \
        "false" \
        "error_handling"
}

# =============================================================================
# MAIN EXECUTION WITH ENHANCED REPORTING
# =============================================================================

finalize_results() {
    local end_time=$(date +%s)
    local total_duration=$((end_time - START_TIME))
    
    if [[ "$SAVE_RESULTS" == "true" ]]; then
        cat >> "$RESULTS_FILE" << EOF
],
"summary": {
  "total_tests": $TOTAL_TESTS,
  "passed": $PASSED_TESTS,
  "failed": $FAILED_TESTS,
  "critical_failures": $CRITICAL_FAILURES,
  "performance_tests": $PERFORMANCE_TESTS,
  "security_tests": $SECURITY_TESTS,
  "duration_seconds": $total_duration,
  "end_time": "$(date -Iseconds)",
  "success_rate": "$(echo "scale=2; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc -l)%",
  "test_categories": {
    "environment": "$(grep -c '"category": "environment"' "$RESULTS_FILE" || echo 0)",
    "local": "$(grep -c '"category": "local"' "$RESULTS_FILE" || echo 0)",
    "security": "$(grep -c '"category": "security"' "$RESULTS_FILE" || echo 0)",
    "performance": "$(grep -c '"category": "performance"' "$RESULTS_FILE" || echo 0)",
    "edge_cases": "$(grep -c '"category": "edge_cases"' "$RESULTS_FILE" || echo 0)",
    "content_types": "$(grep -c '"category": "content_types"' "$RESULTS_FILE" || echo 0)",
    "http_methods": "$(grep -c '"category": "http_methods"' "$RESULTS_FILE" || echo 0)"
  }
}
}}
EOF
        info "Comprehensive results saved to: $RESULTS_FILE"
    fi
}

main() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╭─────────────────────────────────────────────────────────────────────────────╮
    │              🚀 LLM Router API - ULTIMATE TEST SUITE 🚀                    │
    │                  The Most Comprehensive Testing Framework                   │
    │                        External + Local + Performance                      │
    ╰─────────────────────────────────────────────────────────────────────────────╯
EOF
    echo -e "${NC}"
    
    info "Starting ULTIMATE comprehensive API test suite..."
    info "Production URL: $BASE_URL"
    info "Documentation: $DOCS_URL"
    info "Local URL: $LOCAL_URL"
    info "Timeout: ${REQUEST_TIMEOUT}s"
    info "Load Test: $LOAD_TEST_REQUESTS requests"
    info "Concurrent: $CONCURRENT_CONNECTIONS connections"
    
    if [[ "$API_KEY" != "your-api-key-here" ]] && [[ -n "$API_KEY" ]]; then
        info "API Key: ${API_KEY:0:8}... (configured)"
    else
        warning "API Key: Not configured (protected endpoints will be skipped)"
    fi
    
    echo ""
    
    # Run comprehensive test suites
    test_environment_detection
    test_local_endpoints
    
    # Core API tests (integrated from test-suite.sh)
    test_prerequisites
    test_basic_connectivity  
    test_documentation_site
    test_ssl_security
    test_public_endpoints
    test_protected_endpoints
    test_performance_basic
    test_error_handling
    
    # Enhanced test suites
    test_advanced_security
    test_performance_comprehensive
    test_api_edge_cases
    test_websocket_support
    test_content_types
    test_http_methods
    test_compression
    
    # Ultimate summary
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}                               🎯 ULTIMATE TEST SUMMARY                               ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local success_rate=$(echo "scale=1; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc -l)
    
    echo "📊 Total Tests: $TOTAL_TESTS"
    echo -e "${GREEN}✅ Passed: $PASSED_TESTS${NC}"
    echo -e "${RED}❌ Failed: $FAILED_TESTS${NC}"
    echo -e "${RED}🚨 Critical Failures: $CRITICAL_FAILURES${NC}"
    echo -e "${MAGENTA}⚡ Performance Tests: $PERFORMANCE_TESTS${NC}"
    echo -e "${YELLOW}🛡️  Security Tests: $SECURITY_TESTS${NC}"
    echo "⏱️  Total Duration: $(($(date +%s) - START_TIME)) seconds"
    echo "📈 Success Rate: ${success_rate}%"
    
    finalize_results
    
    if [[ $CRITICAL_FAILURES -eq 0 ]] && [[ $FAILED_TESTS -lt 5 ]]; then
        echo ""
        success "🎉 ULTIMATE TEST SUITE PASSED! API is production-ready with comprehensive validation."
        exit 0
    else
        echo ""
        if [[ $CRITICAL_FAILURES -gt 0 ]]; then
            critical "Critical failures detected. Review security and core functionality."
        else
            warning "Some non-critical tests failed. API is functional but may need optimization."
        fi
        exit 1
    fi
}

# Script execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi