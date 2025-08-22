# 🔑 LLM Router Persistent Test Key Setup

This document explains how to use the persistent test API key that's built into the LLM Router server.

## What is the Persistent Test Key?

The LLM Router server automatically creates a **persistent test API key** specifically designed for testing that:

- ✅ **Never changes** - Same key every time
- ✅ **Survives restarts** - Available after server reboots
- ✅ **Survives updates** - Persists through project updates
- ✅ **Pro tier limits** - 10,000 daily requests, 300/minute
- ✅ **Auto-created** - No manual setup required

## How to Get the Persistent Test Key

### Method 1: From LLM Router Server (Recommended)

If you have access to the LLM Router server:

```bash
cd /home/mikecerqua/projects/LLM-Runner-Router
node install-persistent-test-key.js
```

This will display the persistent test key and usage instructions.

### Method 2: From Server Admin

Contact the server administrator to provide you with the persistent test key.

## Using the Persistent Test Key

### Option 1: Environment Variable (Recommended)

```bash
# Export the persistent test key
export ROUTER_API_KEY="[GET_KEY_FROM_SERVER_ADMIN]"

# Run your tests
./functional-llm-router-tests.sh
```

### Option 2: .env File

Create a `.env` file:

```bash
# .env file
API_KEY=[GET_KEY_FROM_SERVER_ADMIN]
BASE_URL=http://178.156.181.117:3000
```

## Security Notes

- ⚠️ **Never commit API keys to version control**
- ⚠️ **Never hardcode keys in scripts**
- ✅ **Use environment variables or .env files**
- ✅ **Add .env to your .gitignore**

## Key Benefits for Testing

1. **Consistent Testing**: Same key across all test runs
2. **No Key Management**: Key automatically maintained by server
3. **High Rate Limits**: Pro tier allows comprehensive testing
4. **Always Available**: Never expires or gets deactivated

## Troubleshooting

### "Invalid API key" Error

1. Verify the key is correct (check with server admin)
2. Ensure server is running with persistent key system
3. Check that you're connecting to the right server URL

### "Rate limit exceeded" Error

The persistent test key has high limits, but if you hit them:
- Wait for the limit to reset (daily/hourly)
- Contact server admin to check key configuration

## Alternative: Generate Your Own Key

If you prefer to use your own API key instead of the persistent one:

```bash
# Use the admin API to create a new key
curl -X POST -H "X-Admin-Key: [ADMIN_KEY]" \
  http://178.156.181.117:3000/api/admin/keys \
  -d '{"name":"My Test Key","tier":"pro"}'
```

This requires admin access to the LLM Router server.