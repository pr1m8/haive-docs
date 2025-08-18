#!/usr/bin/env python3
"""Screenshot haive-mcp documentation to verify template styles."""

import subprocess
import time
from pathlib import Path

import click
from playwright.sync_api import sync_playwright


def take_screenshot(url: str, output_path: str, theme: str = "light"):
    """Take a screenshot of a documentation page."""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1280, "height": 720})

        page.goto(url)

        # Wait for page to load
        page.wait_for_load_state("networkidle")
        time.sleep(1)

        # Toggle dark mode if requested
        if theme == "dark":
            # Look for Furo theme toggle
            try:
                page.click('button[data-theme="dark"]')
                time.sleep(0.5)
            except:
                pass

        # Take screenshot
        page.screenshot(path=output_path, full_page=False)

        # Also take a full page screenshot
        full_path = output_path.replace(".png", "_full.png")
        page.screenshot(path=full_path, full_page=True)

        browser.close()


@click.command()
@click.option("--port", default=8003, help="Port where docs are served")
def main(port):
    """Screenshot haive-mcp documentation."""

    base_url = f"http://localhost:{port}"
    output_dir = Path("debug/screenshots/haive_mcp")
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"📸 Taking screenshots of haive-mcp documentation at {base_url}")

    # Pages to screenshot
    pages = [
        ("index.html", "home"),
        ("autoapi/index.html", "api_index"),
        ("autoapi/mcp/index.html", "mcp_module"),
        ("autoapi/mcp/agents/index.html", "agents_module"),
        ("autoapi/mcp/downloader/index.html", "downloader_module"),
    ]

    for page, name in pages:
        url = f"{base_url}/{page}"
        print(f"📷 Capturing {name}...")

        # Light theme
        light_path = output_dir / f"{name}_light.png"
        take_screenshot(url, str(light_path), "light")

        # Dark theme
        dark_path = output_dir / f"{name}_dark.png"
        take_screenshot(url, str(dark_path), "dark")

    print(f"\n✅ Screenshots saved to {output_dir}")

    # Generate comparison HTML
    html_content = """<!DOCTYPE html>
<html>
<head>
    <title>haive-mcp Documentation Screenshots</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .page { margin-bottom: 40px; border-bottom: 2px solid #ccc; padding-bottom: 20px; }
        .screenshots { display: flex; gap: 20px; margin-top: 10px; }
        .screenshot { flex: 1; }
        img { width: 100%; border: 1px solid #ddd; }
        h2 { color: #333; }
        h3 { color: #666; }
    </style>
</head>
<body>
    <h1>haive-mcp Documentation - Minimal Style</h1>
    <p>Using template style: minimal (no enhanced-design.css)</p>
"""

    for page, name in pages:
        html_content += f"""
    <div class="page">
        <h2>{name.replace('_', ' ').title()}</h2>
        <p>URL: {base_url}/{page}</p>
        <div class="screenshots">
            <div class="screenshot">
                <h3>Light Theme</h3>
                <img src="{name}_light.png" alt="{name} light theme">
            </div>
            <div class="screenshot">
                <h3>Dark Theme</h3>
                <img src="{name}_dark.png" alt="{name} dark theme">
            </div>
        </div>
    </div>
"""

    html_content += """
</body>
</html>"""

    comparison_path = output_dir / "comparison.html"
    comparison_path.write_text(html_content)
    print(f"\n📊 Comparison page: {comparison_path}")


if __name__ == "__main__":
    main()
