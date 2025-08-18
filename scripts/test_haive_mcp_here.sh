#!/bin/bash
# Test PyDevelop-Docs on haive-mcp from current directory

set -e

echo "🧪 Testing PyDevelop-Docs on haive-mcp Package"
echo "============================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Define paths
HAIVE_MCP="/home/will/Projects/haive/backend/haive/packages/haive-mcp"
PYDEVELOP_DOCS="/home/will/Projects/haive/backend/haive/tools/pydevelop-docs"

echo -e "${BLUE}📋 Building haive-mcp Documentation${NC}"
echo "Package: $HAIVE_MCP"
echo ""

# Clean existing docs
echo "🗑️  Cleaning existing haive-mcp docs..."
rm -rf "$HAIVE_MCP/docs"

# Run pydevelop-docs init from haive-mcp directory
echo "🔧 Initializing haive-mcp docs with minimal style..."
(cd "$HAIVE_MCP" && poetry run pydevelop-docs init --template-style minimal --force)

# Check results
echo ""
echo "📊 Checking results..."

# Check if conf.py was created
if [ -f "$HAIVE_MCP/docs/source/conf.py" ]; then
    echo -e "${GREEN}✅ conf.py created successfully${NC}"
    
    # Check for template style
    if grep -q "template style: minimal" "$HAIVE_MCP/docs/source/conf.py"; then
        echo -e "${GREEN}✅ Using minimal template style${NC}"
    fi
    
    # Check CSS files
    echo ""
    echo "📄 CSS files in conf.py:"
    grep -E "html_css_files = \[" -A5 "$HAIVE_MCP/docs/source/conf.py" | grep -E '".+\.css"' | sed 's/^/   /'
    
    # Check actual CSS files copied
    echo ""
    echo "📁 CSS files in _static:"
    find "$HAIVE_MCP/docs/source/_static" -name "*.css" -exec basename {} \; 2>/dev/null | sort | sed 's/^/   - /'
else
    echo -e "${RED}❌ conf.py not created${NC}"
fi

# Build the documentation
echo ""
echo "🏗️  Building haive-mcp documentation..."
(cd "$HAIVE_MCP/docs" && poetry run sphinx-build -b html source build)

# Check build results
if [ -f "$HAIVE_MCP/docs/build/index.html" ]; then
    echo -e "${GREEN}✅ Documentation built successfully${NC}"
    
    # Check for AutoAPI
    if [ -d "$HAIVE_MCP/docs/build/autoapi/haive/mcp" ]; then
        echo -e "${GREEN}✅ AutoAPI generated for haive.mcp${NC}"
        
        # List main modules
        echo ""
        echo "📋 Main MCP modules documented:"
        find "$HAIVE_MCP/docs/build/autoapi/haive/mcp" -maxdepth 1 -name "*.html" -exec basename {} .html \; | grep -v index | sort | sed 's/^/   - /'
    fi
else
    echo -e "${RED}❌ Documentation build failed${NC}"
fi

echo ""
echo -e "${GREEN}✅ Test complete!${NC}"
echo ""
echo "To view the documentation:"
echo "cd $HAIVE_MCP/docs && python -m http.server 8003 --directory build"
echo "Then open: http://localhost:8003"