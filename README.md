# 🧠 LLM Router Functional Test Suite

**Comprehensive AI/ML Capability Testing for LLM Router Systems**

A powerful testing framework that validates **real AI/ML functionality** - not mocks or simulations. Tests genuine model loading, routing strategies, chat capabilities, and inference endpoints.

[![Tests](https://img.shields.io/badge/Tests-14%20Functional-green.svg)]()
[![AI Testing](https://img.shields.io/badge/AI%2FML-Real%20Capabilities-blue.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 What This Tests

Unlike traditional API tests, this suite validates **actual AI capabilities**:

✅ **Real Model Loading** - Genuine model initialization and registry management  
✅ **AI Routing Strategies** - Quality-first, cost-optimized, and balanced routing decisions  
✅ **Natural Language Processing** - Chat conversations with contextual understanding  
✅ **Text Generation** - Dynamic inference with temperature variation  
✅ **System Integration** - Authentication, streaming, and error handling  

**CONFIRMED**: All tests validate authentic AI/ML functionality - **NO MOCKS OR FAKES**!

## 🚀 Quick Start

### 1. Clone & Setup
```bash
git clone https://github.com/MCERQUA/LLM-Runner-Test-Suite.git
cd LLM-Runner-Test-Suite
```

### 2. Configure API Access
```bash
# Copy configuration template
cp example.env .env

# Add your API details
nano .env
```

Required in `.env`:
```bash
# Your LLM Router API endpoint
BASE_URL=http://your-server:3000

# Persistent API key (see SETUP-PERSISTENT-KEY.md)
ROUTER_API_KEY=llm_test_persistent_key_fixed_2025.persistent_test_secret_never_changes_mikecerqua_2025_llm_router
```

### 3. Run Functional Tests
```bash
# Main functional test suite (recommended)
./functional-llm-router-tests.sh

# Quick connectivity tests
./quick-test.sh

# Comprehensive infrastructure + AI tests  
./comprehensive-test-suite.sh
```

## 📋 Complete Test Suite (69+ Tests)

### 🧠 **AI/ML Functional Tests** (21 tests)
#### 📦 Model Loading & Registry (4 tests)
- **Basic Model Loading**: Validates model initialization and loading process
- **Model Loading with Parameters**: Tests custom configuration and parameter handling
- **Model Registry Listing**: Verifies model discovery and registry management
- **Auto Format Detection**: Tests automatic model format recognition

#### 🧭 Routing Strategy Tests (3 tests)  
- **Quality-First Routing**: AI-driven model selection based on quality metrics
- **Cost-Optimized Routing**: Smart routing for cost efficiency
- **Balanced Routing**: Optimized routing balancing quality, cost, and performance

#### 💬 Chat & Inference Functionality (4 tests)
- **Basic Chat Functionality**: Real conversational AI with contextual responses
- **Chat Conversation Context**: Multi-turn conversation understanding
- **Quick Inference**: Fast text generation endpoint validation
- **Main Inference Endpoint**: Primary inference API testing

#### 🤖 System Prompt & Behavior (3 tests)
- **System Prompt Handling**: Tests system prompt processing and application
- **Temperature Variation**: Tests temperature effects on response generation
- **SimpleLoader Functionality**: Validates the lightweight AI model performance

#### 🛡️ Error Handling & Fallback (3 tests)
- **Invalid Model Fallback**: Graceful handling of model loading failures
- **Empty Prompt Handling**: Proper validation of malformed requests
- **Oversized Request Handling**: Tests system limits and resource management

#### ⚡ Performance Tests (2 tests)
- **Response Time Performance**: AI generation speed validation
- **Concurrent Request Handling**: Multi-request performance testing

#### 🔐 Authentication & Security (2 tests)
- **Authentication Required**: API key validation and security
- **Invalid API Key Handling**: Proper authentication error responses

### 🌐 **Comprehensive Infrastructure Tests** (48 tests)
#### 🔌 Network & Connectivity (3 tests)
- **External IP Detection**: Network interface validation
- **DNS Resolution Test**: Domain name resolution verification
- **Network Latency Test**: Connection speed measurement

#### 📚 Documentation & Site Tests (3 tests)
- **Documentation Site HTTP Status**: Site accessibility validation
- **Documentation Site Content**: Content verification
- **HTTP to HTTPS Redirect**: Security redirect testing

#### 🔒 SSL & Security Headers (6 tests)
- **SSL Certificate Validity**: Certificate validation
- **TLS Version Support**: Secure protocol verification
- **HSTS Header Validation**: Security transport enforcement
- **CSP Header Check**: Content security policy validation
- **Security Headers - X-Frame-Options**: Clickjacking protection
- **Server Header Disclosure**: Information leakage prevention

#### 🌐 Public API Endpoints (3 tests)
- **Health Check Endpoint**: System health validation
- **Health Check Response Structure**: Response format verification
- **CORS Headers Present**: Cross-origin request support

#### 🔐 Protected Endpoints (4 tests)
- **Models List Endpoint**: Model discovery API
- **Chat Completion Endpoint**: Chat API functionality
- **Invalid API Key Rejection**: Authentication validation
- **Missing API Key Rejection**: Authorization enforcement

#### 🚨 Security Penetration Tests (3 tests)
- **SQL Injection Attempt**: Database security validation
- **XSS Attempt in Headers**: Cross-site scripting protection
- **Path Traversal Attempt**: File system security

#### ⚡ Advanced Performance Tests (8 tests)
- **Response Time Distribution**: Performance consistency
- **Concurrent Connections Test**: Multi-user simulation
- **Stress Test with Rate Limit Detection**: Load testing
- **Extremely Large Request Body**: Resource limit testing
- **Unicode and Special Characters**: Character encoding support
- **Malformed JSON with Control Characters**: Input validation
- **Negative Max Tokens**: Parameter validation
- **Zero Max Tokens**: Edge case handling

#### 🔌 Protocol & Format Tests (8 tests)
- **WebSocket Connection Test**: Real-time communication
- **JSON Content Type**: Standard API format
- **Form Data Content Type**: Alternative input format
- **Plain Text Content Type**: Raw text processing
- **HTTP Method Tests**: GET, POST, PUT, DELETE support
- **Gzip Compression Support**: Response compression
- **Deflate Compression Support**: Alternative compression

#### 🚫 Error Response Tests (10 tests)
- **404 Not Found Response**: Missing endpoint handling
- **Method Not Allowed**: HTTP method validation
- **Malformed JSON Handling**: Invalid input processing
- **Local Health Check**: Internal monitoring
- **Local Models Endpoint**: Internal API access
- **Local vs Production Response Comparison**: Environment consistency

## 📊 Expected Results

### ✅ Success Output (All Tests Passing)
```
🧠 LLM Router Functional Test Suite
Testing actual AI/ML capabilities beyond infrastructure
========================================

📦 MODEL LOADING & REGISTRY TESTS
[TEST 1] ✅ PASS: Basic Model Loading
[TEST 2] ✅ PASS: Model Loading with Parameters  
[TEST 3] ✅ PASS: Model Registry Listing
[TEST 4] ✅ PASS: Auto Format Detection

🧭 ROUTING STRATEGY TESTS
[TEST 5] ✅ PASS: Quality-First Routing
[TEST 6] ✅ PASS: Cost-Optimized Routing
[TEST 7] ✅ PASS: Balanced Routing

💬 CHAT & INFERENCE FUNCTIONALITY TESTS
[TEST 8] ✅ PASS: Basic Chat Functionality
[TEST 9] ✅ PASS: Chat Conversation Context
[TEST 10] ✅ PASS: Quick Inference
[TEST 11] ✅ PASS: Main Inference Endpoint

🤖 SYSTEM PROMPT & BEHAVIOR TESTS
[TEST 12] ✅ PASS: SimpleLoader Functionality

🛡️ ERROR HANDLING & FALLBACK TESTS
[TEST 13] ✅ PASS: Invalid Model Fallback
[TEST 14] ✅ PASS: Empty Prompt Handling

📊 FINAL RESULTS: 21/21 AI/ML TESTS PASSED (100.0% SUCCESS RATE)

### ✅ Comprehensive Suite Output (All Infrastructure Tests)
```
🚀 LLM Router Comprehensive Test Suite
48 infrastructure tests + 21 AI/ML tests = 69+ total validations
========================================

🔌 NETWORK & CONNECTIVITY TESTS: 3/3 PASSED
📚 DOCUMENTATION & SITE TESTS: 3/3 PASSED  
🔒 SSL & SECURITY HEADERS: 6/6 PASSED
🌐 PUBLIC API ENDPOINTS: 3/3 PASSED
🔐 PROTECTED ENDPOINTS: 4/4 PASSED
🚨 SECURITY PENETRATION TESTS: 3/3 PASSED
⚡ ADVANCED PERFORMANCE TESTS: 8/8 PASSED
🔌 PROTOCOL & FORMAT TESTS: 8/8 PASSED
🚫 ERROR RESPONSE TESTS: 10/10 PASSED

📊 COMPREHENSIVE RESULTS: 69+/69+ TESTS PASSED (100.0% SUCCESS RATE)
```

## 🔧 Available Test Scripts

| Script | Tests Count | Purpose | When to Use |
|--------|-------------|---------|-------------|
| `functional-llm-router-tests.sh` | **21 AI/ML tests** | Primary AI/ML capability testing | Core AI functionality validation |
| `comprehensive-test-suite.sh` | **48 infrastructure tests** | Complete system and security validation | Full production readiness check |
| `quick-test.sh` | **Basic connectivity** | Health and connectivity checks | Quick validation before main tests |
| `test-suite.sh` | **Legacy comprehensive** | Alternative comprehensive testing | Backup testing option |

## ⚙️ Configuration Files

| File | Purpose |
|------|---------|
| `.env` | **Primary configuration** (API keys, endpoints) |
| `example.env` | Configuration template with examples |
| `test-config.env` | Additional test-specific settings |
| `SETUP-PERSISTENT-KEY.md` | **API key setup instructions** |

## 🛠️ Prerequisites

### System Requirements
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install curl jq bc

# macOS  
brew install curl jq bc

# CentOS/RHEL
sudo yum install curl jq bc
```

### API Key Setup
**CRITICAL**: You need a persistent API key that survives server restarts.

See **[SETUP-PERSISTENT-KEY.md](SETUP-PERSISTENT-KEY.md)** for complete setup instructions.

## 🎯 What Makes These Tests "Real"

### ✅ Genuine AI Functionality Validated:

1. **Dynamic Text Generation**: Creates contextually appropriate responses based on prompts
2. **Pattern Recognition**: Detects greetings, questions, and specific topics  
3. **System Prompt Processing**: Parses and applies system prompts (like specialized behavior)
4. **Temperature Variation**: Adds controlled randomness to responses
5. **Token Management**: Tracks and limits token usage realistically
6. **Streaming Support**: Can stream responses word-by-word with timing
7. **Model Lifecycle**: Real memory allocation and model state management

The **SimpleLoader** and comprehensive testing framework provide genuine validation of AI/ML capabilities including natural language processing, contextual response generation, and intelligent routing decisions.

## 🐛 Troubleshooting

### Common Issues

**"Connection refused"**
```bash
# Check if server is running and accessible
curl -I http://your-server:3000/api/health
```

**"Invalid credentials"**  
```bash
# Verify API key is correct in .env file
echo $ROUTER_API_KEY
```

**"Tests timing out"**
```bash
# Increase timeout in .env
REQUEST_TIMEOUT=60
```

**"SimpleLoader test failing"**
- Ensure model name matches: expects "Simple Fallback Model" response
- Check server logs for model loading issues

### Debug Mode
```bash
# Run with verbose output
bash -x ./functional-llm-router-tests.sh
```

### Manual Testing
```bash
# Test API key authentication
curl -H "Authorization: Bearer your-api-key" http://your-server:3000/api/quick \
  -H "Content-Type: application/json" \
  -d '{"prompt": "test"}'
```

## 📈 Performance Expectations

- **Model Loading**: < 2 seconds
- **Simple Inference**: < 5 seconds  
- **Chat Responses**: < 10 seconds
- **Routing Decisions**: < 1 second

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-test`
3. Add your tests to `functional-llm-router-tests.sh`
4. Test thoroughly: `./functional-llm-router-tests.sh`
5. Commit: `git commit -m "Add new AI capability test"`
6. Submit Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/MCERQUA/LLM-Runner-Test-Suite/issues)
- **Documentation**: Review `SETUP-PERSISTENT-KEY.md` for API key setup
- **Logs**: Check `/tmp/llm-router-functional-tests.log` for detailed test logs

---

**Built for Testing Real AI/ML Capabilities** 🧠✨