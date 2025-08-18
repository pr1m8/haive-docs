"""Template style configurations for PyDevelop-Docs."""

from dataclasses import dataclass, field
from typing import Any, Dict, List


@dataclass
class TemplateStyle:
    """Configuration for a documentation template style."""

    name: str
    description: str
    css_files: List[str] = field(default_factory=list)
    js_files: List[str] = field(default_factory=list)
    autoapi_template_dir: str = "_autoapi_templates"
    use_custom_templates: bool = True
    theme_options: Dict[str, Any] = field(default_factory=dict)


# Available template styles
TEMPLATE_STYLES = {
    "minimal": TemplateStyle(
        name="minimal",
        description="Clean, minimal Furo theme with basic enhancements",
        css_files=[
            "breadcrumb-navigation.css",
            "mermaid-custom.css",
            "tippy-enhancements.css",
        ],
        js_files=[
            "js/api-enhancements.js",
        ],
        use_custom_templates=False,  # Use default AutoAPI templates
        theme_options={
            "navigation_with_keys": True,
            "sidebar_hide_name": False,
            "navigation_depth": 4,
        },
    ),
    "modern": TemplateStyle(
        name="modern",
        description="Modern design with cards, gradients, and enhanced styling",
        css_files=[
            "enhanced-design.css",
            "breadcrumb-navigation.css",
            "mermaid-custom.css",
            "tippy-enhancements.css",
        ],
        js_files=[
            "js/api-enhancements.js",
        ],
        use_custom_templates=True,  # Use custom AutoAPI templates
        theme_options={
            "navigation_with_keys": True,
            "sidebar_hide_name": False,
            "navigation_depth": 4,
            "collapse_navigation": False,
        },
    ),
    "classic": TemplateStyle(
        name="classic",
        description="Classic documentation style with API enhancements",
        css_files=[
            "api-docs.css",
            "breadcrumb-navigation.css",
            "mermaid-custom.css",
            "tippy-enhancements.css",
        ],
        js_files=[
            "js/api-enhancements.js",
        ],
        use_custom_templates=True,
        theme_options={
            "navigation_with_keys": True,
            "sidebar_hide_name": False,
            "navigation_depth": 4,
        },
    ),
    "default": TemplateStyle(
        name="default",
        description="Default Furo theme with no customizations",
        css_files=[],
        js_files=[],
        use_custom_templates=False,
        theme_options={
            "navigation_with_keys": True,
        },
    ),
}


def get_template_style(style_name: str = "minimal") -> TemplateStyle:
    """Get a template style configuration by name.

    Args:
        style_name: Name of the template style (minimal, modern, classic, default)

    Returns:
        TemplateStyle configuration
    """
    return TEMPLATE_STYLES.get(style_name, TEMPLATE_STYLES["minimal"])
