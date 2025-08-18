# Template Styles Feature - PyDevelop-Docs

**Created**: 2025-08-18
**Status**: ✅ Implemented
**Branch**: feature/optional-template-styles

## Overview

PyDevelop-Docs now supports multiple template styles, allowing users to choose between different CSS/JS configurations without permanently removing any styles. This preserves both the clean, minimal documentation style and the modern, enhanced design options.

## Available Template Styles

### 1. **minimal** (Default)

- **Description**: Clean, minimal Furo theme with basic enhancements
- **CSS Files**: breadcrumb-navigation.css, mermaid-custom.css, tippy-enhancements.css
- **Best For**: Technical documentation, API references
- **Custom Templates**: No (uses default AutoAPI templates)

### 2. **modern**

- **Description**: Modern design with cards, gradients, and enhanced styling
- **CSS Files**: enhanced-design.css, breadcrumb-navigation.css, mermaid-custom.css, tippy-enhancements.css
- **Best For**: Marketing-oriented docs, product documentation
- **Custom Templates**: Yes (uses custom AutoAPI templates)

### 3. **classic**

- **Description**: Classic documentation style with API enhancements
- **CSS Files**: api-docs.css, breadcrumb-navigation.css, mermaid-custom.css, tippy-enhancements.css
- **Best For**: Traditional API documentation
- **Custom Templates**: Yes

### 4. **default**

- **Description**: Default Furo theme with no customizations
- **CSS Files**: None (only legacy custom.css)
- **Best For**: Users who want pure Furo experience
- **Custom Templates**: No

## Usage

### CLI Usage

```bash
# Initialize with minimal style (default)
poetry run pydevelop-docs init

# Initialize with modern style
poetry run pydevelop-docs init --template-style modern

# Initialize with classic style
poetry run pydevelop-docs init --template-style classic

# Initialize with default Furo (no customizations)
poetry run pydevelop-docs init --template-style default
```

### Switching Styles

To switch between styles on an existing project:

1. Clean the docs directory:

   ```bash
   rm -rf docs/
   ```

2. Re-initialize with desired style:

   ```bash
   poetry run pydevelop-docs init --template-style modern --force
   ```

3. Rebuild documentation:
   ```bash
   cd docs && poetry run sphinx-build -b html source build
   ```

## Implementation Details

### File Structure

```
src/pydevelop_docs/
├── template_styles.py      # Template style definitions
├── cli.py                  # Updated with --template-style option
├── templates/
│   └── static/            # CSS/JS files for all styles
│       ├── enhanced-design.css
│       ├── api-docs.css
│       ├── breadcrumb-navigation.css
│       ├── mermaid-custom.css
│       └── tippy-enhancements.css
```

### How It Works

1. **Style Configuration**: Each style is defined in `template_styles.py` with:
   - CSS files list
   - JS files list
   - Theme options
   - Custom template usage flag

2. **File Distribution**: During `init`, only CSS/JS files for the selected style are copied to `_static/`

3. **Conf.py Generation**: The generated `conf.py` includes:
   - Template style marker comment
   - Correct `html_css_files` list for the style
   - Style-specific theme options
   - Dynamic setup() function

### Example Generated conf.py

```python
# Template style: minimal
# Override CSS files based on template style
html_css_files = ["breadcrumb-navigation.css", "mermaid-custom.css", "tippy-enhancements.css"]

# Template style theme options
html_theme_options.update({
    "navigation_with_keys": True,
    "sidebar_hide_name": False,
    "navigation_depth": 4,
})
```

## Testing

Test all styles with the provided script:

```bash
./scripts/clean_and_test_styles.sh
```

This will:

1. Clean existing docs
2. Initialize with each style
3. Build documentation
4. Report CSS files loaded

## Migration for Existing Packages

For packages that already have enhanced-design.css causing issues:

```bash
# Run the fix script
poetry run python scripts/fix_existing_packages.py /path/to/package

# Or manually:
# 1. Edit conf.py to comment out enhanced-design.css
# 2. Delete enhanced-design.css from _static/
# 3. Rebuild docs
```

## Benefits

1. **Flexibility**: Users can choose the style that fits their needs
2. **Preservation**: No styles are permanently removed
3. **Easy Switching**: Simple to try different styles
4. **Backward Compatible**: Existing projects continue to work
5. **Future Proof**: Easy to add new styles

## Adding New Styles

To add a new template style:

1. Edit `src/pydevelop_docs/template_styles.py`
2. Add new style to `TEMPLATE_STYLES` dict:
   ```python
   "mystyle": TemplateStyle(
       name="mystyle",
       description="My custom style",
       css_files=["my-style.css"],
       js_files=["my-script.js"],
       theme_options={"custom": "options"}
   )
   ```
3. Add CSS/JS files to `templates/static/`
4. Test with `--template-style mystyle`

## Troubleshooting

### CSS Not Loading

- Check that CSS files exist in `docs/source/_static/`
- Verify `html_css_files` in generated `conf.py`
- Clear browser cache

### Wrong Style Applied

- Check `conf.py` for template style marker
- Ensure docs directory was cleaned before re-init
- Verify correct `--template-style` option used

### Build Errors

- Some styles may have more warnings (especially modern)
- Use `--keep-going` flag for Sphinx builds
- Check that all required CSS files were copied
