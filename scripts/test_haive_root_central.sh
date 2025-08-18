#!/bin/bash
# Test PyDevelop-Docs on Haive root directory for centralized documentation

set -e

echo "🧪 Testing PyDevelop-Docs on Haive Root (Central Hub)"
echo "===================================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Define paths
HAIVE_ROOT="/home/will/Projects/haive/backend/haive"

echo -e "${BLUE}📋 Building Haive Root Documentation (Central Hub)${NC}"
echo "Location: $HAIVE_ROOT"
echo ""

# Clean existing docs
echo "🗑️  Cleaning existing root docs..."
rm -rf "$HAIVE_ROOT/docs"

# Initialize with minimal style and extra sections for central hub
echo "🔧 Initializing root docs as central hub..."
(cd "$HAIVE_ROOT" && poetry run pydevelop-docs init \
    --template-style minimal \
    --with-guides \
    --with-examples \
    --with-tutorials \
    --force)

# Check results
echo ""
echo "📊 Checking results..."

# Check if conf.py was created
CONF_FILE="$HAIVE_ROOT/docs/source/conf.py"
if [ -f "$CONF_FILE" ]; then
    echo -e "${GREEN}✅ conf.py created successfully${NC}"
    
    # Check for central hub configuration
    if grep -q "get_central_hub_config\|get_haive_config.*is_central_hub" "$CONF_FILE"; then
        echo -e "${GREEN}✅ Using central hub configuration${NC}"
    else
        echo -e "${YELLOW}⚠️  Not using central hub configuration${NC}"
    fi
    
    # Check for template style
    if grep -q "template style: minimal" "$CONF_FILE"; then
        echo -e "${GREEN}✅ Using minimal template style${NC}"
    fi
else
    echo -e "${RED}❌ conf.py not created${NC}"
fi

# Check index.rst structure
INDEX_FILE="$HAIVE_ROOT/docs/source/index.rst"
if [ -f "$INDEX_FILE" ]; then
    echo ""
    echo "📄 Index.rst TOC Structure:"
    echo "-------------------------"
    grep -E "^\.\. toctree::|:caption:|guides/index|examples/index|tutorials/index|autoapi/index|:maxdepth:" "$INDEX_FILE" | head -20
    echo "-------------------------"
fi

# Build the documentation
echo ""
echo "🏗️  Building Haive root documentation..."
(cd "$HAIVE_ROOT/docs" && poetry run sphinx-build -b html source build -W --keep-going 2>&1 | tail -30)

# Check build results
if [ -f "$HAIVE_ROOT/docs/build/index.html" ]; then
    echo -e "${GREEN}✅ Documentation built successfully${NC}"
    
    # Check for package documentation
    echo ""
    echo "📦 Checking for package documentation:"
    
    # List packages found
    if [ -d "$HAIVE_ROOT/docs/build/autoapi" ]; then
        echo "📋 AutoAPI generated for:"
        find "$HAIVE_ROOT/docs/build/autoapi" -maxdepth 2 -name "index.html" -path "*/haive/*" | while read -r file; do
            dir=$(dirname "$file")
            package=$(basename "$dir")
            echo "   - $package"
        done
    fi
else
    echo -e "${RED}❌ Documentation build failed${NC}"
fi

echo ""
echo -e "${GREEN}✅ Test complete!${NC}"
echo ""
echo "To view the documentation:"
echo "cd $HAIVE_ROOT/docs && python -m http.server 8005 --directory build"
echo "Then open: http://localhost:8005"