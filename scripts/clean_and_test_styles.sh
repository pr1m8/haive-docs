#!/bin/bash
# Clean and test PyDevelop-Docs with different template styles

set -e

echo "🧹 PyDevelop-Docs Template Style Testing Script"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to test a specific style
test_style() {
    local STYLE=$1
    echo -e "${BLUE}📋 Testing template style: ${STYLE}${NC}"
    
    # Clean existing docs
    echo "  🗑️  Removing existing docs directory..."
    rm -rf docs/
    
    # Run pydevelop-docs init with the style
    echo "  🔧 Running: poetry run pydevelop-docs init --template-style ${STYLE}"
    poetry run pydevelop-docs init --template-style ${STYLE} --force
    
    # Check if conf.py was created
    if [ -f "docs/source/conf.py" ]; then
        echo -e "  ${GREEN}✅ conf.py created successfully${NC}"
        
        # Check for style marker in conf.py
        if grep -q "template style: ${STYLE}" docs/source/conf.py; then
            echo -e "  ${GREEN}✅ Template style '${STYLE}' found in conf.py${NC}"
        else
            echo -e "  ${RED}❌ Template style marker missing in conf.py${NC}"
        fi
        
        # Build the docs
        echo "  🏗️  Building documentation..."
        cd docs && poetry run sphinx-build -b html source build -W --keep-going 2>&1 | tail -20
        cd ..
        
        if [ -f "docs/build/index.html" ]; then
            echo -e "  ${GREEN}✅ Documentation built successfully${NC}"
            
            # Count CSS files loaded
            CSS_COUNT=$(find docs/source/_static -name "*.css" 2>/dev/null | wc -l)
            echo -e "  📊 CSS files in _static: ${CSS_COUNT}"
            
            # List CSS files
            echo "  📄 CSS files:"
            find docs/source/_static -name "*.css" -exec basename {} \; 2>/dev/null | sort | sed 's/^/     - /'
        else
            echo -e "  ${RED}❌ Documentation build failed${NC}"
        fi
    else
        echo -e "  ${RED}❌ conf.py not created${NC}"
    fi
    
    echo ""
}

# Go to test project directory
cd test-projects/test-haive-template || {
    echo -e "${RED}❌ Error: test-projects/test-haive-template not found${NC}"
    echo "Please run from the pydevelop-docs root directory"
    exit 1
}

echo -e "${YELLOW}📍 Working directory: $(pwd)${NC}"
echo ""

# Test each style
for style in minimal modern classic default; do
    test_style $style
    echo "----------------------------------------"
    echo ""
done

echo -e "${GREEN}✅ All template styles tested!${NC}"
echo ""
echo "To view the documentation for a specific style:"
echo "1. Run: poetry run pydevelop-docs init --template-style <style>"
echo "2. Build: cd docs && poetry run sphinx-build -b html source build"
echo "3. Serve: python -m http.server 8003 --directory docs/build"
echo "4. Open: http://localhost:8003"