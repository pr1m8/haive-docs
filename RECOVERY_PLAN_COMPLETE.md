# Complete Recovery Plan: From Good to Bad to Fixed

**Date**: 2025-08-18
**Purpose**: Complete timeline, recovery plan, and testing strategy

## 📅 Timeline: When Things Were Good vs Bad

### ✅ **GOOD Period: Aug 8-12**

**What worked:**

- Simple Sphinx setup with basic extensions
- Clean Furo theme without aggressive overrides
- Just `custom.css` for minor tweaks
- Documentation was readable and navigable

**Evidence:**

- Initial commits show minimal CSS
- No enhanced-design.css yet
- No template experiments

### ⚠️ **TURNING POINT: Aug 13**

**What changed:**

- Added 9+ CSS/JS files (commit `384eff9`)
- Added `api-docs.css` with badges and gradients
- Still somewhat okay but getting complex

**Key commit:**

```
384eff9 - fix: resolve static file copying issue - complete CSS and JS distribution
```

### 🔥 **DISASTER: Aug 15**

**Everything broke:**

- Added `enhanced-design.css` (20KB marketing CSS)
- Multiple template experiments in ONE day
- Created broken backup templates
- Added dropdowns, cards, hero sections

**Key commits:**

```
090d988 - feat(templates): enhance AutoAPI templates with modern design and dropdowns
31e74b6 - feat(autoapi): comprehensive template customization for modern documentation
```

**This is when docs became "terrible"**

### ⚠️ **FAILED FIX: Aug 17**

**Attempted recovery:**

- Removed enhanced-design.css from config.py
- BUT didn't update CLI
- BUT didn't clean packages
- Result: Fixes ignored everywhere

**Key commits:**

```
09d1862 - fix: remove aggressive CSS styling to restore clean documentation
a6ca772 - docs(css): complete CSS simplification
```

## 🎯 End-to-End Recovery Plan

### **Step 1: Preparation (30 mins)**

```bash
# 1. Create recovery branch
git checkout -b recovery/documentation-complete-fix

# 2. Document current state
poetry run python scripts/screenshot_specific.py \
  "http://localhost:8003/autoapi/mcp/comprehensive_mcp_web/index.html" \
  "before_recovery"

# 3. Backup current state
cp -r src/pydevelop_docs/templates src/pydevelop_docs/templates.backup
git add -A && git commit -m "backup: Before recovery attempt"
```

### **Step 2: Fix CLI Generation (1 hour)**

**File**: `src/pydevelop_docs/cli.py`

```python
# Line 320 - Remove from static_files list
# REMOVE: ("static/enhanced-design.css", "docs/source/_static/enhanced-design.css"),

# Line 445 - Fix html_css_files
html_css_files = [
    # "enhanced-design.css",  # REMOVED
    "breadcrumb-navigation.css",
    "mermaid-custom.css",
    "tippy-enhancements.css"
]

# Line 655 - Fix second html_css_files
# Same as above

# Line 731 - Fix setup() function
def setup(app):
    """Sphinx setup hook."""
    # Don't override CSS - let config handle it
    app.add_css_file("css/custom.css")  # Legacy only
    app.add_js_file("js/api-enhancements.js")
```

### **Step 3: Fix Configuration (1 hour)**

**File**: `src/pydevelop_docs/config.py`

```python
# Add source code viewing fixes
"autoapi_python_use_implicit_namespaces": True,
"autoapi_add_toctree_entry": True,
"autoapi_keep_files": True,
"autoapi_generate_api_docs": True,

# Fix paths for nested pages
"html_baseurl": "/",
"html_static_path": ["_static"],

# Add GitHub integration for source links
"html_context": {
    "display_github": True,
    "github_user": "pr1m8",
    "github_repo": "haive",
    "github_version": "main",
    "conf_py_path": "/docs/source/",
}
```

### **Step 4: Clean Templates (30 mins)**

```bash
# 1. Remove broken experiments
rm -rf src/pydevelop_docs/templates/_autoapi_templates_BROKEN_BACKUP

# 2. Disable bad CSS
mv src/pydevelop_docs/templates/static/enhanced-design.css \
   src/pydevelop_docs/templates/static/enhanced-design.css.DISABLED

mv src/pydevelop_docs/templates/static/api-docs.css \
   src/pydevelop_docs/templates/static/api-docs.css.DISABLED

# 3. Simplify AutoAPI templates (optional)
# Either delete custom templates to use defaults
# OR fix the custom templates
```

### **Step 5: Test with One Package (1 hour)**

```bash
# Use haive-mcp as test subject
cd /home/will/Projects/haive/backend/haive/packages/haive-mcp

# 1. Clean everything
rm -rf docs/build
rm -rf docs/source/_static/enhanced-design.css
rm -rf docs/source/_static/api-docs.css
rm -rf docs/source/_autoapi_templates

# 2. Regenerate with fixed PyDevelop-Docs
cd /home/will/Projects/haive/backend/haive/tools/pydevelop-docs
poetry run pydevelop-docs init --force \
  --project-path /home/will/Projects/haive/backend/haive/packages/haive-mcp

# 3. Build
cd /home/will/Projects/haive/backend/haive/packages/haive-mcp
poetry run sphinx-build -b html docs/source docs/build

# 4. Serve and test
python -m http.server 8003 --directory docs/build
```

### **Step 6: Visual Testing Checklist**

**Test these pages specifically:**

1. **Index Page** (`http://localhost:8003/index.html`)
   - [ ] Navigation sidebar visible
   - [ ] CSS loaded (check developer tools)
   - [ ] No white-on-white text
   - [ ] Clean Furo theme (not marketing style)

2. **API Index** (`http://localhost:8003/autoapi/index.html`)
   - [ ] Package name "haive-mcp" visible
   - [ ] Module list shows correctly
   - [ ] No aggressive cards/gradients

3. **Nested Module** (`http://localhost:8003/autoapi/mcp/agents/index.html`)
   - [ ] CSS still loads (was failing before)
   - [ ] Navigation still visible
   - [ ] Breadcrumbs work

4. **Class Page** (`http://localhost:8003/autoapi/mcp/agents/mcp_agent/index.html`)
   - [ ] Source code link present
   - [ ] "View Source" button works
   - [ ] Clean code formatting

### **Step 7: Screenshot Testing**

```bash
# Run visual tests
cd /home/will/Projects/haive/backend/haive/tools/pydevelop-docs

# Test specific problem page
poetry run python scripts/screenshot_specific.py \
  "http://localhost:8003/autoapi/mcp/comprehensive_mcp_web/index.html" \
  "after_recovery"

# Run comprehensive test
poetry run python scripts/comprehensive_screenshot.py 8003

# Analyze results
poetry run python scripts/analyze_screenshot_results.py
```

**Expected improvements:**

- Navigation sidebar on ALL pages (was 0%)
- CSS loads on ALL pages (was 10%)
- No more "terrible" looking pages

### **Step 8: Apply to All Packages (2 hours)**

```bash
# If tests pass, apply to all
cd /home/will/Projects/haive/backend/haive/tools/pydevelop-docs

# Run the build all script
poetry run python scripts/build_all_haive_docs.py \
  --clean \
  --force \
  --test

# Check results
ls -la /home/will/Projects/haive/backend/haive/docs/build/
```

## 📊 Testing Strategy

### **Visual Comparison**

**Before Recovery:**

- White-on-white text
- Missing navigation
- Aggressive marketing CSS
- Broken on nested pages

**After Recovery Target:**

- Clean Furo theme
- Navigation on all pages
- Readable text
- Working source links

### **Automated Tests**

```python
# Create test script: test_recovery.py
import requests
from bs4 import BeautifulSoup

def test_page(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Check navigation exists
    nav = soup.find('nav', class_='sidebar-tree')
    assert nav is not None, "Navigation missing"

    # Check CSS loaded
    css_links = soup.find_all('link', rel='stylesheet')
    css_files = [link.get('href') for link in css_links]
    assert not any('enhanced-design.css' in f for f in css_files), "Bad CSS still loaded"

    # Check source links
    view_source = soup.find('a', string='View Source')
    print(f"Source link present: {view_source is not None}")

    return True

# Test key pages
test_page("http://localhost:8003/index.html")
test_page("http://localhost:8003/autoapi/index.html")
test_page("http://localhost:8003/autoapi/mcp/agents/index.html")
```

## 🎯 Success Criteria

### **Must Have:**

1. ✅ Navigation sidebar on 100% of pages
2. ✅ CSS loads on nested pages
3. ✅ No enhanced-design.css anywhere
4. ✅ Readable text (no white-on-white)

### **Should Have:**

1. ✅ Source code viewing works
2. ✅ Package names in TOC
3. ✅ Clean URLs without issues

### **Nice to Have:**

1. ✅ Breadcrumb navigation
2. ✅ Search functionality
3. ✅ Mobile responsive

## 📋 Final Validation

```bash
# 1. Check no bad CSS remains
find /home/will/Projects/haive/backend/haive/packages \
  -name "enhanced-design.css" \
  -o -name "api-docs.css" | wc -l
# Should be 0

# 2. Check all packages built
ls -la /home/will/Projects/haive/backend/haive/packages/*/docs/build/index.html | wc -l
# Should be 7

# 3. Run final screenshot test
poetry run python scripts/visual_test_runner.py \
  --package haive-mcp \
  --full-test

# 4. Review the before/after screenshots
xdg-open debug/screenshots/comparison.html
```

## 🚀 Go/No-Go Decision

**After Step 6 testing:**

- If haive-mcp looks good → Proceed to all packages
- If still broken → Debug what's wrong
- If partially fixed → Decide what's acceptable

**Remember**: The goal is readable, navigable documentation. Not perfect, just functional.

**Total Time**: 6-8 hours with testing
**Best Time**: Start fresh in the morning
