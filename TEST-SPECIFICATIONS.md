# 🧠 LLM Router Functional Test Specifications

**Complete Test Documentation for AI/ML Capability Validation**

This document provides detailed specifications for all 14+ functional tests that validate real AI/ML capabilities in the LLM Router system.

## 📋 Complete Test Inventory

### 📦 MODEL LOADING & REGISTRY TESTS

#### TEST 1: Basic Model Loading
- **Function**: `test_basic_model_loading()`
- **Endpoint**: `POST /api/models/load`
- **Purpose**: Validates basic model initialization and loading
- **Payload**: 
  ```json
  {
    "source": "simple",
    "id": "test-basic-model",
    "name": "Basic Test Model"
  }
  ```
- **Success Criteria**: 
  - HTTP 200 response
  - Model successfully loaded message
- **AI Capability Tested**: Model lifecycle management

#### TEST 2: Model Loading with Parameters
- **Function**: `test_model_loading_with_parameters()`
- **Endpoint**: `POST /api/models/load` 
- **Purpose**: Tests custom configuration and parameter handling
- **Payload**:
  ```json
  {
    "source": "simple",
    "id": "param-test-model",
    "name": "Parameter Test Model",
    "maxTokens": 200,
    "temperature": 0.8
  }
  ```
- **Success Criteria**: HTTP 200 with parameter acknowledgment
- **AI Capability Tested**: Model configuration management

#### TEST 3: Model Registry Listing
- **Function**: `test_model_registry_listing()`
- **Endpoint**: `GET /api/models`
- **Purpose**: Verifies model discovery and registry management
- **Success Criteria**: 
  - HTTP 200 response
  - JSON array with at least 1 model
  - Model count validation
- **AI Capability Tested**: Model registry and discovery

#### TEST 4: Auto Format Detection
- **Function**: `test_auto_format_detection()`
- **Endpoint**: `POST /api/models/load`
- **Purpose**: Tests automatic model format recognition
- **Payload**:
  ```json
  {
    "source": "simple",
    "format": "simple",
    "id": "auto-detect-test",
    "name": "Auto Detection Test Model"
  }
  ```
- **Success Criteria**: HTTP 200 with format detection
- **AI Capability Tested**: Automatic format identification

### 🧭 ROUTING STRATEGY TESTS

#### TEST 5: Quality-First Routing
- **Function**: `test_routing_strategy_quality_first()`
- **Endpoint**: `POST /api/route`
- **Purpose**: AI-driven model selection based on quality metrics
- **Payload**:
  ```json
  {
    "prompt": "Quality-first routing test prompt",
    "strategy": "quality-first",
    "maxTokens": 50
  }
  ```
- **Success Criteria**: 
  - HTTP 200 response
  - Strategy confirmation in response
  - Valid model selection
- **AI Capability Tested**: Intelligent routing decisions

#### TEST 6: Cost-Optimized Routing  
- **Function**: `test_routing_strategy_cost_optimized()`
- **Endpoint**: `POST /api/route`
- **Purpose**: Smart routing for cost efficiency
- **Payload**:
  ```json
  {
    "prompt": "Cost optimization test prompt",
    "strategy": "cost-optimized",
    "maxTokens": 50
  }
  ```
- **Success Criteria**: Cost-optimized model selection
- **AI Capability Tested**: Economic routing optimization

#### TEST 7: Balanced Routing
- **Function**: `test_routing_strategy_balanced()`
- **Endpoint**: `POST /api/route`
- **Purpose**: Optimized routing balancing multiple factors
- **Payload**:
  ```json
  {
    "prompt": "Balanced routing test prompt",
    "strategy": "balanced",
    "maxTokens": 50
  }
  ```
- **Success Criteria**: Balanced strategy implementation
- **AI Capability Tested**: Multi-factor routing optimization

### 💬 CHAT & INFERENCE FUNCTIONALITY TESTS

#### TEST 8: Basic Chat Functionality
- **Function**: `test_chat_basic_functionality()`
- **Endpoint**: `POST /api/chat`
- **Purpose**: Real conversational AI with contextual responses
- **Payload**:
  ```json
  {
    "messages": [
      {"role": "user", "content": "Hello, can you help me test the chat functionality?"}
    ],
    "maxTokens": 100,
    "temperature": 0.7
  }
  ```
- **Success Criteria**: 
  - HTTP 200 response
  - Valid response text (>10 characters)
  - Contextually appropriate content
- **AI Capability Tested**: Natural language conversation

#### TEST 9: Chat Conversation Context
- **Function**: `test_chat_conversation_context()`
- **Endpoint**: `POST /api/chat`
- **Purpose**: Multi-turn conversation understanding
- **Payload**:
  ```json
  {
    "messages": [
      {"role": "user", "content": "My name is Alice"},
      {"role": "assistant", "content": "Hello Alice, nice to meet you!"},
      {"role": "user", "content": "What is my name?"}
    ],
    "maxTokens": 50
  }
  ```
- **Success Criteria**: Context-aware response
- **AI Capability Tested**: Conversation memory and context

#### TEST 10: Quick Inference
- **Function**: `test_quick_inference()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Fast text generation endpoint validation
- **Payload**:
  ```json
  {
    "prompt": "Generate a short creative story about a robot",
    "maxTokens": 150,
    "temperature": 0.8
  }
  ```
- **Success Criteria**: Creative text generation
- **AI Capability Tested**: Rapid inference and creativity

#### TEST 11: Main Inference Endpoint
- **Function**: `test_main_inference_endpoint()`
- **Endpoint**: `POST /api/inference`
- **Purpose**: Primary inference API testing
- **Payload**:
  ```json
  {
    "prompt": "Explain the concept of machine learning in simple terms",
    "maxTokens": 200,
    "model": "simple-fallback"
  }
  ```
- **Success Criteria**: Comprehensive explanatory response
- **AI Capability Tested**: Educational content generation

### 🤖 SYSTEM PROMPT & BEHAVIOR TESTS

#### TEST 12: SimpleLoader Functionality
- **Function**: `test_simple_loader_functionality()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Validates lightweight AI model performance
- **Payload**:
  ```json
  {
    "prompt": "test",
    "model": "simple-fallback"
  }
  ```
- **Success Criteria**: 
  - HTTP 200 response
  - Model field contains "Simple Fallback Model"
  - Valid response generation
- **AI Capability Tested**: Lightweight model intelligence

#### TEST 13: System Prompt Handling
- **Function**: `test_system_prompt_handling()`
- **Endpoint**: `POST /api/chat`
- **Purpose**: Tests system prompt processing and application
- **Payload**:
  ```json
  {
    "messages": [
      {"role": "system", "content": "You are a helpful monkey who loves ice cream"},
      {"role": "user", "content": "Hello, what's your favorite flavor?"}
    ],
    "maxTokens": 100
  }
  ```
- **Success Criteria**: Behavior modification per system prompt
- **AI Capability Tested**: System prompt integration

#### TEST 14: Temperature Variation
- **Function**: `test_temperature_variation()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Tests temperature effects on response generation
- **Test Process**: 
  - Run same prompt with temperature 0.2 (conservative)
  - Run same prompt with temperature 0.9 (creative)
  - Compare response variation
- **Success Criteria**: Different responses showing temperature effect
- **AI Capability Tested**: Response randomness control

### 🛡️ ERROR HANDLING & FALLBACK TESTS

#### TEST 15: Invalid Model Fallback
- **Function**: `test_invalid_model_fallback()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Graceful handling of model loading failures
- **Payload**:
  ```json
  {
    "prompt": "Test fallback behavior",
    "model": "nonexistent-model"
  }
  ```
- **Success Criteria**: Graceful fallback to available model
- **AI Capability Tested**: Fault tolerance and recovery

#### TEST 16: Empty Prompt Handling
- **Function**: `test_empty_prompt_handling()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Proper validation of malformed requests
- **Payload**:
  ```json
  {
    "prompt": "",
    "maxTokens": 50
  }
  ```
- **Success Criteria**: HTTP 400 Bad Request
- **AI Capability Tested**: Input validation

#### TEST 17: Oversized Request Handling
- **Function**: `test_oversized_request_handling()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Tests system limits and resource management
- **Payload**: Very long prompt (1000+ words)
- **Success Criteria**: Graceful handling (200, 400, or 413)
- **AI Capability Tested**: Resource management

### ⚡ PERFORMANCE TESTS

#### TEST 18: Response Time Performance
- **Function**: `test_response_time_performance()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: AI generation speed validation
- **Payload**:
  ```json
  {
    "prompt": "Quick response test",
    "maxTokens": 50
  }
  ```
- **Success Criteria**: 
  - HTTP 200 response
  - Response time < 10 seconds
- **AI Capability Tested**: Inference speed optimization

#### TEST 19: Concurrent Request Handling
- **Function**: `test_concurrent_requests()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Multi-request performance testing
- **Process**: 
  - Launch 3 simultaneous requests
  - Wait for all to complete
  - Validate no crashes or conflicts
- **Success Criteria**: All concurrent requests complete successfully
- **AI Capability Tested**: Parallel processing capability

### 🔐 AUTHENTICATION & SECURITY TESTS

#### TEST 20: Authentication Required
- **Function**: `test_authentication_required()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: API key validation and security
- **Process**: Make request without API key
- **Success Criteria**: HTTP 401 Unauthorized
- **AI Capability Tested**: Security enforcement

#### TEST 21: Invalid API Key Handling
- **Function**: `test_invalid_api_key()`
- **Endpoint**: `POST /api/quick`
- **Purpose**: Proper authentication error responses
- **Process**: Use invalid API key
- **Success Criteria**: HTTP 401 with error message
- **AI Capability Tested**: Authentication validation

## 🔍 Test Execution Flow

### Initialization Phase
1. Load configuration from `.env` file
2. Validate required tools (curl, jq, bc)
3. Test basic connectivity to API endpoint
4. Verify API key authentication

### Test Execution Phase
1. **Model Loading Tests**: Ensure AI models can be loaded and managed
2. **Routing Strategy Tests**: Validate intelligent model selection
3. **Chat & Inference Tests**: Test core AI capabilities
4. **System Behavior Tests**: Verify specialized AI behaviors
5. **Error Handling Tests**: Ensure graceful failure management
6. **Performance Tests**: Validate speed and concurrency
7. **Security Tests**: Confirm authentication and authorization

### Reporting Phase
1. Calculate success/failure rates
2. Generate detailed logs to `/tmp/llm-router-functional-tests.log`
3. Display summary with color-coded results
4. Exit with appropriate status code

## 📊 Success Metrics

### Individual Test Success
- **HTTP Status**: Correct status codes (200, 400, 401, etc.)
- **Response Content**: Valid JSON with expected fields
- **AI Quality**: Contextually appropriate responses
- **Performance**: Response times within acceptable limits

### Overall Suite Success
- **Pass Rate**: Target 100% (14/14 tests passing)
- **Response Quality**: All AI responses demonstrate intelligence
- **Performance**: All tests complete within timeout limits
- **Security**: Authentication properly enforced

### Quality Indicators
- **Contextual Relevance**: AI responses match prompt context
- **Behavioral Consistency**: System prompts properly applied
- **Error Handling**: Graceful failure with informative messages
- **Resource Management**: No memory leaks or crashes

## 🔧 Validation Methods

### Response Validation
```bash
# Example validation logic
if [ "$status" -eq 200 ]; then
    if echo "$body" | grep -q '"response"'; then
        local response_text=$(echo "$body" | grep -o '"response":"[^"]*"' | cut -d'"' -f4)
        if [ ${#response_text} -gt 10 ]; then
            return 0  # Success
        fi
    fi
fi
```

### AI Quality Assessment
- **Length Check**: Responses must be substantive (>10 characters)
- **Content Validation**: Must contain expected fields
- **Context Relevance**: Responses should relate to prompts
- **Format Compliance**: JSON structure must be valid

### Performance Measurement
- **Response Time**: Measured using curl timing
- **Concurrency**: Multiple parallel requests handled
- **Resource Usage**: No excessive memory consumption
- **Stability**: No crashes under load

---

**This specification ensures comprehensive testing of real AI/ML capabilities, not mocks or simulations.**