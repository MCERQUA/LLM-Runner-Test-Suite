#!/usr/bin/env node

/**
 * 🔑 Create Test API Key for Functional Testing
 * Adds a test API key to the LLM Router system
 */

import { APIKeyManager } from '/home/mikecerqua/projects/LLM-Runner-Router/src/auth/APIKeyManager.js';
import path from 'path';

async function createTestKey() {
  console.log('🔑 Creating test API key for functional testing...');
  
  try {
    const manager = new APIKeyManager({
      keysFile: '/home/mikecerqua/projects/LLM-Runner-Router/data/api-keys.json'
    });
    
    await manager.initialize();
    
    const result = await manager.createAPIKey({
      name: 'Functional Test User',
      email: 'functional-test@example.com',
      tier: 'basic'
    });
    
    console.log('✅ Test API key created successfully!');
    console.log(`🔑 Key ID: ${result.keyId}`);
    console.log(`🎫 Full Key: ${result.fullKey}`);
    console.log(`🎯 Tier: ${result.tier}`);
    console.log('');
    console.log('📝 To use this key in tests:');
    console.log(`export ROUTER_API_KEY="${result.fullKey}"`);
    console.log('');
    console.log('🔄 Or add to test script:');
    console.log(`ROUTER_API_KEY="${result.fullKey}" ./functional-llm-router-tests.sh`);
    
    return result.fullKey;
  } catch (error) {
    console.error('❌ Failed to create test API key:', error.message);
    process.exit(1);
  }
}

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  createTestKey();
}

export { createTestKey };