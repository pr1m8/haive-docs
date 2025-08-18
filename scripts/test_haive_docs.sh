#!/bin/bash
# Test PyDevelop-Docs on Haive root and haive-mcp package

set -e

echo "🧪 Testing PyDevelop-Docs on Haive Project"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Test 1: Haive Root Documentation (Central Hub)
echo -e "${BLUE}📋 Test 1: Building Haive Root Documentation${NC}"
echo "Location: /home/will/Projects/haive/backend/haive"
echo ""

cd /home/will/Projects/haive/backend/haive

# Clean existing docs
echo "🗑️  Cleaning existing root docs..."
rm -rf docs/

# Initialize with minimal style (recommended)
echo "🔧 Initializing root docs with minimal style..."
poetry run pydevelop-docs init --template-style minimal --force

# Check if conf.py was created
if [ -f "docs/source/conf.py" ]; then
    echo -e "${GREEN}✅ Root conf.py created successfully${NC}"
    
    # Check for central hub configuration
    if grep -q "get_central_hub_config" docs/source/conf.py; then
        echo -e "${GREEN}✅ Using central hub configuration${NC}"
    else
        echo -e "${YELLOW}⚠️  Not using central hub configuration${NC}"
    fi
else
    echo -e "${RED}❌ Root conf.py not created${NC}"
fi

# Build the documentation
echo "🏗️  Building root documentation..."
cd docs && poetry run sphinx-build -b html source build -W --keep-going 2>&1 | tail -20
cd ..

if [ -f "docs/build/index.html" ]; then
    echo -e "${GREEN}✅ Root documentation built successfully${NC}"
else
    echo -e "${RED}❌ Root documentation build failed${NC}"
fi

echo ""
echo "----------------------------------------"
echo ""

# Test 2: Haive-MCP Package Documentation
echo -e "${BLUE}📋 Test 2: Building haive-mcp Package Documentation${NC}"
echo "Location: /home/will/Projects/haive/backend/haive/packages/haive-mcp"
echo ""

cd /home/will/Projects/haive/backend/haive/packages/haive-mcp

# Clean existing docs
echo "🗑️  Cleaning existing haive-mcp docs..."
rm -rf docs/

# Initialize with minimal style
echo "🔧 Initializing haive-mcp docs with minimal style..."
poetry run pydevelop-docs init --template-style minimal --force

# Check if conf.py was created
if [ -f "docs/source/conf.py" ]; then
    echo -e "${GREEN}✅ haive-mcp conf.py created successfully${NC}"
    
    # Check for shared config
    if grep -q "from pydevelop_docs.config import get_haive_config" docs/source/conf.py; then
        echo -e "${GREEN}✅ Using shared PyDevelop-Docs configuration${NC}"
    fi
    
    # Check CSS files
    echo "📄 CSS files configured:"
    grep -A5 "html_css_files" docs/source/conf.py | grep -E '".+\.css"' | sed 's/^/   /'
else
    echo -e "${RED}❌ haive-mcp conf.py not created${NC}"
fi

# Build the documentation
echo "🏗️  Building haive-mcp documentation..."
cd docs && poetry run sphinx-build -b html source build -W --keep-going 2>&1 | tail -20
cd ..

if [ -f "docs/build/index.html" ]; then
    echo -e "${GREEN}✅ haive-mcp documentation built successfully${NC}"
    
    # Check for AutoAPI content
    if [ -d "docs/build/autoapi/haive/mcp" ]; then
        echo -e "${GREEN}✅ AutoAPI generated for haive.mcp module${NC}"
        
        # Count generated API pages
        API_COUNT=$(find docs/build/autoapi -name "*.html" | wc -l)
        echo "📊 API pages generated: $API_COUNT"
    else
        echo -e "${RED}❌ AutoAPI not generated${NC}"
    fi
else
    echo -e "${RED}❌ haive-mcp documentation build failed${NC}"
fi

echo ""
echo "----------------------------------------"
echo ""

# Summary
echo -e "${BLUE}📊 Test Summary${NC}"
echo ""

# Check CSS files in haive-mcp
echo "haive-mcp CSS files in _static:"
find /home/will/Projects/haive/backend/haive/packages/haive-mcp/docs/source/_static -name "*.css" 2>/dev/null | xargs basename -a | sort | sed 's/^/  - /'

echo ""
echo -e "${GREEN}✅ Testing complete!${NC}"
echo ""
echo "To view the documentation:"
echo "1. Root docs: cd /home/will/Projects/haive/backend/haive/docs && python -m http.server 8003 --directory build"
echo "2. haive-mcp: cd /home/will/Projects/haive/backend/haive/packages/haive-mcp/docs && python -m http.server 8004 --directory build"