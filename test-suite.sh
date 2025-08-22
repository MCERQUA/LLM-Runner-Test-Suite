#!/bin/bash

# LLM Router API - Comprehensive Test Suite
# Public repository version - Safe for distribution
# No API keys or sensitive data included

set -euo pipefail

# =============================================================================
# CONFIGURATION AND SETUP
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

# Default values (fallback if not in config)
API_KEY="${API_KEY:-your-api-key-here}"
BASE_URL="${BASE_URL:-https://api.llmrouter.dev}"
DOCS_URL="${DOCS_URL:-https://llmrouter.dev}"
REQUEST_TIMEOUT="${REQUEST_TIMEOUT:-30}"
MAX_TOKENS="${MAX_TOKENS:-100}"
TEST_MODEL="${TEST_MODEL:-auto}"
VERBOSE_LOGGING="${VERBOSE_LOGGING:-true}"
SAVE_RESULTS="${SAVE_RESULTS:-true}"
RESULTS_DIR="${RESULTS_DIR:-./test-results}"

# Colors for output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Test tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
START_TIME=$(date +%s)

# Results storage
if [[ "$SAVE_RESULTS" == "true" ]]; then
    mkdir -p "$RESULTS_DIR"
    RESULTS_FILE="$RESULTS_DIR/test-results-$(date +%Y%m%d-%H%M%S).json"
    echo "{\"test_run\":{\"start_time\":\"$(date -Iseconds)\",\"tests\":[" > "$RESULTS_FILE"
fi

# =============================================================================
# UTILITY FUNCTIONS
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

# Test execution function
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    local is_critical="${4:-false}"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    local test_start=$(date +%s%N)
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "TEST $TOTAL_TESTS: $test_name"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ "$VERBOSE_LOGGING" == "true" ]]; then
        echo "Command: $test_command"
    fi
    
    # Execute test
    local output
    local exit_code
    output=$(eval "$test_command" 2>&1) || exit_code=$?
    exit_code=${exit_code:-0}
    
    local test_end=$(date +%s%N)
    local duration=$(( (test_end - test_start) / 1000000 )) # Convert to milliseconds
    
    # Evaluate test result
    local test_passed=false
    if [[ $exit_code -eq 0 ]]; then
        if [[ -n "$expected_pattern" ]]; then
            if echo "$output" | grep -q "$expected_pattern"; then
                test_passed=true
            fi
        else
            test_passed=true
        fi
    fi
    
    # Display results
    if [[ "$test_passed" == "true" ]]; then
        success "PASSED ($duration ms)"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        if [[ "$is_critical" == "true" ]]; then
            error "FAILED (CRITICAL) - Exit code: $exit_code"
        else
            error "FAILED - Exit code: $exit_code"
        fi
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    
    # Show output
    if [[ "$VERBOSE_LOGGING" == "true" ]] || [[ "$test_passed" == "false" ]]; then
        echo "Response:"
        echo "$output"
    fi
    
    # Save to results file
    if [[ "$SAVE_RESULTS" == "true" ]]; then
        local comma=""
        [[ $TOTAL_TESTS -gt 1 ]] && comma=","
        cat >> "$RESULTS_FILE" << EOF
$comma{
  "test_number": $TOTAL_TESTS,
  "name": "$test_name",
  "command": "$test_command",
  "expected_pattern": "$expected_pattern",
  "passed": $test_passed,
  "critical": $is_critical,
  "exit_code": $exit_code,
  "duration_ms": $duration,
  "output": $(echo "$output" | jq -Rs .)
}
EOF
    fi
    
    # Exit on critical failure if specified
    if [[ "$is_critical" == "true" ]] && [[ "$test_passed" == "false" ]]; then
        error "Critical test failed. Aborting test suite."
        finalize_results
        exit 1
    fi
}

# =============================================================================
# TEST SUITE FUNCTIONS
# =============================================================================

test_prerequisites() {
    log "Checking prerequisites..."
    
    # Check required tools
    local tools=("curl" "jq")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            error "Required tool '$tool' not found. Please install it."
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
        "true"
    
    run_test "DNS Resolution" \
        "curl -s --connect-timeout 5 --head $(echo $BASE_URL | sed 's|https\?://||' | cut -d'/' -f1):443 >/dev/null 2>&1 && echo 'DNS Resolution: Success'" \
        "DNS Resolution: Success" \
        "true"
}

test_documentation_site() {
    log "Testing documentation site..."
    
    run_test "Documentation Site HTTP Status" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT '$DOCS_URL'" \
        "200"
    
    run_test "Documentation Site Content" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$DOCS_URL'" \
        "LLM Router API"
    
    run_test "HTTP to HTTPS Redirect" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT '$(echo $DOCS_URL | sed 's/https/http/')'" \
        "301"
}

test_ssl_security() {
    log "Testing SSL and security..."
    
    local domain=$(echo $BASE_URL | sed 's|https\?://||' | cut -d'/' -f1)
    
    run_test "SSL Certificate Validity" \
        "echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates" \
        "notAfter"
    
    run_test "TLS Version Support" \
        "echo | openssl s_client -servername $domain -connect $domain:443 -tls1_3 2>/dev/null | grep 'Protocol'" \
        "TLSv1.3"
    
    run_test "Security Headers - HSTS" \
        "curl -s -I --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        "Strict-Transport-Security"
    
    run_test "Security Headers - X-Frame-Options" \
        "curl -s -I --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        "X-Frame-Options"
}

test_public_endpoints() {
    log "Testing public endpoints..."
    
    run_test "Health Check Endpoint" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        '"status":"healthy"' \
        "true"
    
    run_test "Health Check Response Structure" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health' | jq -e '.status and .initialized and .engine'" \
        "true"
    
    run_test "CORS Headers Present" \
        "curl -s -I --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/health'" \
        "Access-Control-Allow"
}

test_protected_endpoints() {
    if [[ "$API_KEY" == "your-api-key-here" ]] || [[ -z "$API_KEY" ]]; then
        warning "Skipping protected endpoint tests (no API key configured)"
        return
    fi
    
    log "Testing protected endpoints..."
    
    run_test "Models List Endpoint" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -H 'X-API-Key: $API_KEY' '$BASE_URL/api/models'" \
        "models"
    
    run_test "Chat Completion Endpoint" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{\"message\":\"Hello, this is a test\",\"model\":\"$TEST_MODEL\",\"max_tokens\":$MAX_TOKENS}'" \
        "response\\|content\\|message"
    
    run_test "Invalid API Key Rejection" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -H 'X-API-Key: invalid-key-test-12345' '$BASE_URL/api/models'" \
        "error\\|unauthorized\\|invalid\\|403\\|401"
    
    run_test "Missing API Key Rejection" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/models'" \
        "error\\|unauthorized\\|missing\\|403\\|401"
}

test_performance() {
    log "Testing performance..."
    
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
        ""
}

test_error_handling() {
    log "Testing error handling..."
    
    run_test "404 Not Found Response" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT '$BASE_URL/api/nonexistent'" \
        "404"
    
    run_test "Method Not Allowed" \
        "curl -s -o /dev/null -w '%{http_code}' --connect-timeout $REQUEST_TIMEOUT -X PATCH '$BASE_URL/api/health'" \
        "405\\|404"
    
    run_test "Malformed JSON Handling" \
        "curl -s --connect-timeout $REQUEST_TIMEOUT -X POST '$BASE_URL/api/chat' \\
        -H 'Content-Type: application/json' \\
        -H 'X-API-Key: $API_KEY' \\
        -d '{invalid json}'" \
        "error\\|400\\|Bad Request"
}

# =============================================================================
# MAIN EXECUTION
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
  "duration_seconds": $total_duration,
  "end_time": "$(date -Iseconds)",
  "success_rate": $(echo "scale=2; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc -l)%
}
}}
EOF
        info "Results saved to: $RESULTS_FILE"
    fi
}

main() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╭─────────────────────────────────────────────────────────────────────────────╮
    │                    🚀 LLM Router API Test Suite 🚀                         │
    │                         Comprehensive Testing Framework                     │
    ╰─────────────────────────────────────────────────────────────────────────────╯
EOF
    echo -e "${NC}"
    
    info "Starting comprehensive API test suite..."
    info "Base URL: $BASE_URL"
    info "Documentation: $DOCS_URL"
    info "Timeout: ${REQUEST_TIMEOUT}s"
    
    if [[ "$API_KEY" != "your-api-key-here" ]] && [[ -n "$API_KEY" ]]; then
        info "API Key: ${API_KEY:0:8}... (configured)"
    else
        warning "API Key: Not configured (protected endpoints will be skipped)"
    fi
    
    echo ""
    
    # Run test suites
    test_prerequisites
    test_basic_connectivity
    test_documentation_site
    test_ssl_security
    test_public_endpoints
    test_protected_endpoints
    test_performance
    test_error_handling
    
    # Final summary
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}                                   🎯 TEST SUMMARY                                   ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local success_rate=$(echo "scale=1; $PASSED_TESTS * 100 / $TOTAL_TESTS" | bc -l)
    
    echo "📊 Total Tests: $TOTAL_TESTS"
    echo -e "${GREEN}✅ Passed: $PASSED_TESTS${NC}"
    echo -e "${RED}❌ Failed: $FAILED_TESTS${NC}"
    echo "⏱️  Duration: $(($(date +%s) - START_TIME)) seconds"
    echo "📈 Success Rate: ${success_rate}%"
    
    finalize_results
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo ""
        success "🎉 ALL TESTS PASSED! API is fully operational and production-ready."
        exit 0
    else
        echo ""
        error "⚠️  Some tests failed. Please review the output above for details."
        exit 1
    fi
}

# Script execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi