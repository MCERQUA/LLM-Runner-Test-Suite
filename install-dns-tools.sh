#!/bin/bash

# DNS Tools Installation Script
# Automatically detects OS and installs dig/host commands

echo "🔧 DNS Tools Installation Script"
echo "================================="

# Detect operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt-get >/dev/null 2>&1; then
        echo "📦 Detected: Ubuntu/Debian system"
        echo "Running: sudo apt update && sudo apt install -y dnsutils"
        sudo apt update && sudo apt install -y dnsutils
    elif command -v yum >/dev/null 2>&1; then
        echo "📦 Detected: Red Hat/CentOS system"
        echo "Running: sudo yum install -y bind-utils"
        sudo yum install -y bind-utils
    elif command -v dnf >/dev/null 2>&1; then
        echo "📦 Detected: Fedora/Rocky/Alma system"
        echo "Running: sudo dnf install -y bind-utils"
        sudo dnf install -y bind-utils
    else
        echo "❌ Unsupported Linux distribution"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "📦 Detected: macOS system"
    if command -v brew >/dev/null 2>&1; then
        echo "Running: brew install bind"
        brew install bind
    else
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash/WSL)
    echo "📦 Detected: Windows system"
    echo "For WSL, run: sudo apt update && sudo apt install -y dnsutils"
    echo "For Git Bash, DNS tools should be available via Windows"
else
    echo "❌ Unsupported operating system: $OSTYPE"
    exit 1
fi

# Test installation
echo ""
echo "🧪 Testing DNS tools installation..."
if command -v dig >/dev/null 2>&1; then
    echo "✅ dig command: AVAILABLE"
    dig +short google.com
else
    echo "❌ dig command: NOT AVAILABLE"
fi

if command -v host >/dev/null 2>&1; then
    echo "✅ host command: AVAILABLE"
    host google.com | head -1
else
    echo "❌ host command: NOT AVAILABLE"
fi

echo ""
echo "🎯 Installation complete! You can now run the comprehensive test suite."