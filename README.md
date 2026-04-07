# pydevelop-docs

[![PyPI version](https://img.shields.io/pypi/v/pydevelop-docs.svg)](https://pypi.org/project/pydevelop-docs/)
[![Python Versions](https://img.shields.io/pypi/pyversions/pydevelop-docs.svg)](https://pypi.org/project/pydevelop-docs/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI](https://github.com/pr1m8/haive-docs/actions/workflows/ci.yml/badge.svg)](https://github.com/pr1m8/haive-docs/actions/workflows/ci.yml)
[![PyPI Downloads](https://img.shields.io/pypi/dm/pydevelop-docs.svg)](https://pypi.org/project/pydevelop-docs/)

> **Universal Python documentation generator with 40+ Sphinx extensions pre-configured.**
> Zero-configuration setup for beautiful, professional documentation.

`pydevelop-docs` is the docs build system used by the Haive monorepo. It bundles 40+ Sphinx extensions, custom CSS/JS, AutoAPI configuration, and a CLI for one-command documentation builds. Designed for monorepos, but works for any Python project.

---

## Why pydevelop-docs?

Setting up Sphinx for a real project is painful. You need to:

- Pick the right extensions (and there are hundreds)
- Configure AutoAPI to organize docs hierarchically (not flat)
- Wire up theme, CSS, JS, dark mode
- Handle Pydantic models, type hints, mermaid diagrams, code highlighting
- Make it work for monorepos with cross-package linking
- Build all packages in dependency order

`pydevelop-docs` gives you all of this with one command:

```bash
pydevelop-docs build --clean
```

---

## Features

### 🚀 Zero-config build
- 40+ Sphinx extensions pre-configured
- Furo theme with dark mode
- AutoAPI hierarchical organization (`autoapi_own_page_level = "module"`)
- Pre-built CSS for code visibility, navigation, dark mode

### 📦 Monorepo support
- Build all packages in dependency order
- Master documentation hub with cross-package linking
- Per-package builds for individual development

### 🎨 Beautiful defaults
- Furo theme (purple/violet, dark mode)
- Mermaid + PlantUML diagrams
- Interactive tooltips (sphinx-tippy)
- Code copybutton
- Inline tabs
- AutoAPI hierarchical layout

### 🔧 Pydantic support
- Auto-detects Pydantic models
- Renders with `autodoc-pydantic`
- Field validation, default values, examples

### 🧪 Visual testing
- Playwright screenshot tools
- Light + dark theme captures
- Issue detection (white-on-white, missing nav, etc.)

---

## Extension List (40+)

| Category | Extensions |
|----------|------------|
| **Core** | autodoc, napoleon, viewcode, intersphinx, todo, coverage, mathjax |
| **API Docs** | autoapi, sphinx_autodoc_typehints, autodoc_pydantic |
| **Enhanced Docs** | myst_parser, copybutton, togglebutton, design, tabs, inline_tabs |
| **Diagramming** | mermaid, plantuml, blockdiag, seqdiag, graphviz |
| **Code** | codeautolink, exec_code, runpython |
| **UI** | tippy, favicon, sphinxemoji |
| **Utilities** | sitemap, last_updated_by_git, opengraph, reredirects, treeview, enum_tools, sphinx_toolbox |

---

## Installation

```bash
pip install pydevelop-docs
```

---

## Quick Start

### For a single Python project

```bash
cd your-project/

# Initialize Sphinx config
poetry run pydevelop-docs init

# Build
poetry run pydevelop-docs build --clean

# Serve locally
cd docs/build && python -m http.server 8000
```

### For a monorepo

```bash
cd your-monorepo/

# Build all packages with dependency-aware ordering
poetry run pydevelop-docs build-all --clean

# Or use the enhanced builder with monitoring
poetry run pydevelop-docs rebuild-haive --debug --save-log
```

---

## CLI Commands

```bash
# Initialize a new docs setup
pydevelop-docs init

# Build single package
pydevelop-docs build [--clean] [--ignore-warnings]

# Build all packages in monorepo
pydevelop-docs build-all [--clean]

# Enhanced rebuild with monitoring (best for large projects)
pydevelop-docs rebuild-haive --debug --save-log

# Watch mode for development
pydevelop-docs watch
```

---

## Configuration

### Default config
```python
# docs/source/conf.py
from pydevelop_docs.config import get_haive_config
config = get_haive_config(package_name="my-package")
globals().update(config)
```

### Customize
```python
# docs/source/conf.py
from pydevelop_docs.config import get_haive_config

config = get_haive_config(
    package_name="my-package",
    project="My Project",
    author="My Name",
    extensions_extra=["my_custom_extension"],
)
globals().update(config)
```

---

## Visual Testing

```bash
# Build and serve
poetry run sphinx-build -b html docs/source docs/build
python -m http.server 8003 --directory docs/build

# Take screenshots (light + dark, all major pages)
poetry run python scripts/debug/comprehensive_screenshot.py 8003

# Specific page
poetry run python scripts/debug/screenshot_specific.py \
    "http://localhost:8003/autoapi/index.html" \
    "autoapi_test"
```

---

## Used By

- [Haive AI Agent Framework](https://github.com/pr1m8/haive) — 8 sub-packages, 1000+ pages of generated docs

---

## License

MIT © [pr1m8](https://github.com/pr1m8)
