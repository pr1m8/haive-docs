#!/bin/bash
# Test enhanced TOC tree on haive-core package

set -e

echo "🧪 Testing Enhanced TOC Tree on haive-core"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Define paths
HAIVE_CORE="/home/will/Projects/haive/backend/haive/packages/haive-core"
PYDEVELOP_DOCS="/home/will/Projects/haive/backend/haive/tools/pydevelop-docs"

echo -e "${BLUE}📋 Building haive-core Documentation with Enhanced TOC${NC}"
echo "Package: $HAIVE_CORE"
echo ""

# Clean existing docs
echo "🗑️  Cleaning existing haive-core docs..."
rm -rf "$HAIVE_CORE/docs"

# Run pydevelop-docs init with minimal style and extra sections
echo "🔧 Initializing haive-core docs with enhanced TOC..."
(cd "$HAIVE_CORE" && poetry run pydevelop-docs init \
    --template-style minimal \
    --with-guides \
    --with-examples \
    --force)

# Check results
echo ""
echo "📊 Checking results..."

# Check if index.rst was created
INDEX_FILE="$HAIVE_CORE/docs/source/index.rst"
if [ -f "$INDEX_FILE" ]; then
    echo -e "${GREEN}✅ index.rst created successfully${NC}"
    
    # Check TOC structure
    echo ""
    echo "📄 TOC Structure in index.rst:"
    echo "------------------------------"
    grep -E "^\.\. toctree::|:caption:|guides/index|examples/index|autoapi/index|:maxdepth:" "$INDEX_FILE" | head -20
    echo "------------------------------"
else
    echo -e "${RED}❌ index.rst not created${NC}"
fi

# Build the documentation
echo ""
echo "🏗️  Building haive-core documentation..."
(cd "$HAIVE_CORE/docs" && poetry run sphinx-build -b html source build 2>&1 | tail -20)

# Check build results
if [ -f "$HAIVE_CORE/docs/build/index.html" ]; then
    echo -e "${GREEN}✅ Documentation built successfully${NC}"
    
    # Check for AutoAPI structure
    if [ -d "$HAIVE_CORE/docs/build/autoapi/haive/core" ]; then
        echo -e "${GREEN}✅ AutoAPI generated for haive.core${NC}"
        
        # List main core modules
        echo ""
        echo "📋 Main core modules documented:"
        find "$HAIVE_CORE/docs/build/autoapi/haive/core" -maxdepth 1 -name "*.html" -exec basename {} .html \; | grep -v index | sort | sed 's/^/   - /'
    fi
else
    echo -e "${RED}❌ Documentation build failed${NC}"
fi

echo ""
echo -e "${GREEN}✅ Test complete!${NC}"
echo ""
echo "To view the documentation:"
echo "cd $HAIVE_CORE/docs && python -m http.server 8004 --directory build"
echo "Then open: http://localhost:8004"