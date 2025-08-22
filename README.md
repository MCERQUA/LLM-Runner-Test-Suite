# 🚀 LLM Router API Test Suite

A comprehensive testing framework for the LLM Router API, designed to validate all endpoints, security features, and performance characteristics from external networks.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Language-Shell-green.svg)](https://www.gnu.org/software/bash/)
[![API Testing](https://img.shields.io/badge/Type-API%20Testing-blue.svg)]()

## 🌟 Features

- **🔒 Security-First**: No hardcoded API keys, environment-based configuration
- **🌐 External Testing**: Tests from outside the server network for real-world validation
- **📊 Comprehensive Coverage**: Tests all public and protected endpoints
- **🛡️ SSL/TLS Validation**: Certificate and security header verification
- **⚡ Performance Metrics**: Response time and concurrent request testing
- **📝 Detailed Reporting**: JSON output with test results and timings
- **🎨 Rich CLI Output**: Colored output with progress indicators
- **🔧 Configurable**: Extensive configuration options via environment variables

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/LLM-Runner-Test-Suite.git
cd LLM-Runner-Test-Suite
```

### 2. Configure Your Environment

```bash
# Copy the example configuration
cp example.env .env

# Edit the configuration with your API details
nano .env
```

### 3. Run the Test Suite

```bash
# Run the comprehensive test suite
./test-suite.sh

# The script will automatically detect your configuration
```

## ⚙️ Configuration

### Required Configuration

Edit `.env` file with your API details:

```bash
# Your LLM Router API Key (required for protected endpoints)
API_KEY=sk-your-actual-api-key-here

# Base URL for your LLM Router API
BASE_URL=https://api.llmrouter.dev

# Documentation URL
DOCS_URL=https://llmrouter.dev
```

### Optional Configuration

The following settings have sensible defaults but can be customized:

```bash
# Request timeout (default: 30 seconds)
REQUEST_TIMEOUT=30

# Maximum tokens for chat tests (default: 100)
MAX_TOKENS=100

# Enable verbose logging (default: true)
VERBOSE_LOGGING=true

# Save results to JSON file (default: true)
SAVE_RESULTS=true
```

See [`example.env`](example.env) for all available configuration options.

## 🧪 Test Categories

### 🔌 Basic Connectivity
- Internet connectivity verification
- DNS resolution testing
- Network reachability validation

### 📚 Documentation Site
- Documentation site accessibility
- HTTP to HTTPS redirect verification
- Content validation

### 🔒 SSL & Security
- SSL certificate validity
- TLS version support (TLS 1.3)
- Security headers verification (HSTS, X-Frame-Options, etc.)

### 🌐 Public Endpoints
- Health check endpoint (`/api/health`)
- Response structure validation
- CORS headers verification

### 🔐 Protected Endpoints
*Requires valid API key in configuration*
- Models list endpoint (`/api/models`)
- Chat completion endpoint (`/api/chat`)
- API key validation
- Authentication error handling

### ⚡ Performance Testing
- Response time measurement
- Concurrent request handling
- Load testing capabilities

### 🚨 Error Handling
- 404 Not Found responses
- Method not allowed handling
- Malformed request processing

## 📊 Output and Reporting

### Console Output

The test suite provides rich, colored console output with:
- ✅ Pass/fail indicators
- ⏱️ Response time measurements
- 📈 Progress tracking
- 🎯 Final summary with success rate

### JSON Reports

When `SAVE_RESULTS=true`, detailed JSON reports are saved to `./test-results/`:

```json
{
  "test_run": {
    "start_time": "2024-01-15T10:30:00Z",
    "tests": [
      {
        "test_number": 1,
        "name": "Health Check Endpoint",
        "passed": true,
        "duration_ms": 125,
        "output": "..."
      }
    ],
    "summary": {
      "total_tests": 15,
      "passed": 14,
      "failed": 1,
      "success_rate": "93.3%"
    }
  }
}
```

## 🛠️ Prerequisites

### System Requirements

- **Operating System**: Linux, macOS, or WSL on Windows
- **Shell**: Bash 4.0 or later
- **Network**: Internet connection for external API testing

### Required Tools

The following tools must be installed and available in your PATH:

```bash
# Install on Ubuntu/Debian
sudo apt update
sudo apt install curl jq bc openssl

# Install on macOS (with Homebrew)
brew install curl jq bc openssl

# Install on CentOS/RHEL
sudo yum install curl jq bc openssl
```

### Tool Verification

You can verify prerequisites by running:

```bash
./test-suite.sh
# The script will check for required tools and report any missing dependencies
```

## 🔧 Advanced Usage

### Custom Base URL

Test against a different API instance:

```bash
# Edit .env file
BASE_URL=https://api-staging.llmrouter.dev

# Or set temporarily
BASE_URL=http://localhost:3001 ./test-suite.sh
```

### Skip Protected Endpoints

Run tests without an API key (public endpoints only):

```bash
# Remove or comment out API_KEY in .env
# API_KEY=

./test-suite.sh
```

### Performance Testing

Adjust performance test parameters:

```bash
# In .env file
CONCURRENT_REQUESTS=10
PERFORMANCE_TEST_DURATION=120
RATE_LIMIT_REQUESTS=20
```

### Development Testing

For local development with self-signed certificates:

```bash
# In .env file (NOT recommended for production)
SKIP_SSL_VERIFY=true
BASE_URL=https://localhost:3001
```

## 🐛 Troubleshooting

### Common Issues

#### "API Key Not Configured"
- **Cause**: Missing or invalid API key in `.env` file
- **Solution**: Ensure `API_KEY=your-actual-key` is set in `.env`

#### "Connection Timeout"
- **Cause**: Network connectivity issues or server downtime
- **Solution**: Check `BASE_URL` and verify server is accessible

#### "SSL Certificate Error"
- **Cause**: Invalid or expired SSL certificate
- **Solution**: Verify the API endpoint is properly configured with valid SSL

#### "Required Tool Not Found"
- **Cause**: Missing dependency (curl, jq, bc, or openssl)
- **Solution**: Install missing tools using your system package manager

### Debug Mode

Enable verbose logging for troubleshooting:

```bash
# In .env file
VERBOSE_LOGGING=true

# Or run with debug output
bash -x ./test-suite.sh
```

### Manual Testing

You can also test individual endpoints manually:

```bash
# Health check
curl -s https://api.llmrouter.dev/api/health | jq '.'

# With API key
curl -s -H "X-API-Key: your-key" https://api.llmrouter.dev/api/models | jq '.'
```

## 📋 Example Output

```
🚀 LLM Router API Test Suite
════════════════════════════════════════════════════════════════════════════════

ℹ️  Starting comprehensive API test suite...
ℹ️  Base URL: https://api.llmrouter.dev
ℹ️  Documentation: https://llmrouter.dev
ℹ️  Timeout: 30s
ℹ️  API Key: sk-abc123... (configured)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[10:30:01] TEST 1: Health Check Endpoint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED (125 ms)

[... additional tests ...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                                   🎯 TEST SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Total Tests: 15
✅ Passed: 15
❌ Failed: 0
⏱️  Duration: 8 seconds
📈 Success Rate: 100.0%

✅ 🎉 ALL TESTS PASSED! API is fully operational and production-ready.
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test your changes: `./test-suite.sh`
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [https://llmrouter.dev](https://llmrouter.dev)
- **Issues**: [GitHub Issues](https://github.com/yourusername/LLM-Runner-Test-Suite/issues)
- **API Support**: Contact your LLM Router API provider

## 🔗 Related Projects

- [LLM Router API Documentation](https://llmrouter.dev)
- [LLM Router Dashboard](https://dashboard.llmrouter.dev)

---

Made with ❤️ for robust API testing