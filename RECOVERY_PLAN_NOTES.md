# PyDevelop-Docs Recovery Plan Notes

**Generated**: 2025-08-18
**Purpose**: Comprehensive analysis for recovering documentation system

## Current State Analysis

### 1. Test Results Summary

#### Screenshot Test Sessions

- **Session 1**: comprehensive_20250817_183249 (before fixes)
- **Session 2**: comprehensive_20250817_184958 (after partial fixes)
- **Total Pages Tested**: 20 pages × 2 themes = 40 pages per session

#### Critical Issues Found:

1. **Navigation Sidebar Missing**: 100% of pages (CRITICAL)
2. **CSS Loading Failures**:
   - Session 1: 0 CSS files on ALL pages
   - Session 2: 25 CSS files on index pages only, 0 on module pages (90% broken)
3. **TOC Tree Missing**: 90% of pages
4. **Source Links Missing**: 90% of pages

#### Working vs Broken:

- **Partially Working**: `/index.html`, `/autoapi/index.html` (2 pages)
- **Completely Broken**: All module/submodule pages (18 pages)

### 2. File Modification Timeline

#### Key CSS Files (in templates/static/):

- **enhanced-design.css** (20KB) - Modified Aug 15 07:55 - Marketing-style aggressive CSS
- **api-docs.css** (7KB) - Modified Aug 13 16:27 - Badges and gradients
- **toc-enhancements.css** (7.5KB) - Modified Aug 13 16:27
- **mermaid-custom.css** (6KB) - Modified Aug 13 16:27
- **tippy-enhancements.css** (4.5KB) - Modified Aug 13 16:27
- **breadcrumb-navigation.css** (2.8KB) - Modified Aug 15 15:21
- **css/furo-intense.css** - Modified Aug 15 06:03

#### Key Python Files:

- **config.py** - Modified Aug 17 19:54 (latest, has fixes)
- **cli.py** - Modified Aug 15 18:10 (has hardcoded bad CSS)
- **template_manager.py** - Modified Aug 15 15:21

#### Template Files:

- **\_autoapi_templates/** - Created Aug 15 10:31-13:22
- **\_autoapi_templates_BROKEN_BACKUP/** - Created Aug 15 05:09-15:29

### 3. Configuration Chaos

#### Multiple CSS Lists Found:

**In config.py (GOOD - Latest):**

```python
"html_css_files": [
    # "enhanced-design.css",  # REMOVED
    "breadcrumb-navigation.css",
    "mermaid-custom.css",
    "tippy-enhancements.css",
],
```

**In cli.py (BAD - 4 locations):**

- Line 320: File copy operation
- Line 445: html_css_files list
- Line 655: Another html_css_files list
- Line 731: CSS files in setup() function

**Result**: Packages import good config but override with bad CSS list in setup()

### 4. Git History Analysis

#### CSS Simplification Timeline:

- **Aug 17**: Multiple commits to remove marketing CSS
  - 09d1862: "fix: remove aggressive CSS styling"
  - a6ca772: "docs(css): complete CSS simplification"
- **Aug 15**: Added modern design features
  - 090d988: "feat(templates): enhance AutoAPI templates with modern design"
  - 20907a1: "feat: implement breadcrumb navigation"
- **Aug 13**: Initial CSS fixes
  - df36ff7: "fix(css): resolve comprehensive light mode text visibility"

### 5. Root Causes Identified

1. **Configuration Override Pattern**: Packages use centralized config but override CSS in setup()
2. **Path Issues**: CSS/JS use relative paths that break in nested pages
3. **Template Confusion**: Multiple template versions, some broken
4. **Import Failures**: AutoAPI can't find modules (empty navigation)
5. **Inconsistent Updates**: Config.py updated but cli.py still generates old patterns

### 6. Physical File State

#### In Haive Packages (e.g., haive-mcp):

- **Still has enhanced-design.css** in \_static/
- **Still loads it** in conf.py line 42
- **Result**: All CSS simplification work is ignored

#### In PyDevelop-Docs:

- **templates/static/**: Contains all CSS files including bad ones
- **config.py**: Has good configuration
- **cli.py**: Generates bad configuration

## Recovery Plan

### Phase 1: Fix Configuration Generation

1. Update cli.py to remove enhanced-design.css from all 4 locations
2. Fix setup() function to not override CSS files
3. Ensure generated conf.py files fully respect centralized config

### Phase 2: Clean Existing Packages

1. Delete enhanced-design.css from all package \_static/ directories
2. Regenerate conf.py files with corrected PyDevelop-Docs
3. Fix path issues for CSS/JS loading in nested pages

### Phase 3: Fix AutoAPI Module Discovery

1. Investigate why modules aren't being found
2. Check import paths and autoapi_dirs configuration
3. Ensure packages can be imported by AutoAPI

### Phase 4: Template Cleanup

1. Remove or fix broken templates in \_autoapi_templates_BROKEN_BACKUP
2. Consolidate template versions
3. Ensure consistent template usage

### Phase 5: Rebuild and Test

1. Rebuild all packages with corrected configuration
2. Run visual tests to verify fixes
3. Ensure navigation, CSS, and content all work

## Critical Files to Fix

1. **cli.py** - Lines 320, 445, 655, 731 (remove enhanced-design.css)
2. **All package conf.py files** - Remove setup() CSS override
3. **All package \_static/ directories** - Delete enhanced-design.css
4. **Template paths** - Fix relative path issues

## Success Metrics

- [ ] Navigation sidebar appears on all pages
- [ ] CSS loads on all pages (not just index)
- [ ] Module content appears in documentation
- [ ] TOC tree visible on all pages
- [ ] No marketing-style aggressive CSS
- [ ] Clean Furo theme appearance
