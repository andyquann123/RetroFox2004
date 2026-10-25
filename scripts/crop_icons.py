import argparse
import os
import shutil
from PIL import Image

def main():
    parser = argparse.ArgumentParser(description="Extract RetroFox 2004 Winstripe icons from Firefox 1.0 classic.jar")
    parser.add_argument("--classic-jar", default=None, help="Path to classic.jar from Firefox 1.0")
    parser.add_argument("--extracted", default=None, help="Path to an already extracted classic.jar directory")
    parser.add_argument("--out", default=None, help="Output icons directory")
    args = parser.parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, ".."))
    out_dir = args.out or os.path.join(project_root, "chrome", "RetroFox2004", "icons")
    os.makedirs(out_dir, exist_ok=True)

    # Resolve source sprite
    if args.extracted:
        extracted = args.extracted
    elif args.classic_jar:
        import zipfile
        extracted = os.path.join(project_root, "source", "classic_extracted")
        os.makedirs(extracted, exist_ok=True)
        with zipfile.ZipFile(args.classic_jar) as z:
            z.extractall(extracted)
    else:
        extracted = os.path.join(project_root, "source", "classic_extracted")

    sprite_path = os.path.join(extracted, "skin", "classic", "browser", "Toolbar.png")
    if not os.path.exists(sprite_path):
        raise SystemExit("Toolbar.png not found. Provide --classic-jar or --extracted.")

    buttons = [
        "back", "forward", "stop", "reload", "home",
        "downloads", "history", "bookmarks", "print",
        "new-tab", "new-window", "cut", "copy", "paste", "mail",
    ]
    img = Image.open(sprite_path).convert("RGBA")
    states = [("normal", 0), ("hover", 1), ("disabled", 2)]
    for col, name in enumerate(buttons):
        for state, row in states:
            x = col * 24
            y = row * 24
            crop = img.crop((x, y, x + 24, y + 24))
            crop.save(os.path.join(out_dir, f"{name}-{state}.png"))

    src_browser = os.path.join(extracted, "skin", "classic", "browser")
    extras = ["Go.png", "Secure.png", "Security-broken.png", "Info.png",
             "Throbber-small.png", "Bookmarks-folder.png", "Throbber.png",
             "Throbber-small.gif"]
    for ex in extras:
        p = os.path.join(src_browser, ex)
        if os.path.exists(p):
            shutil.copy2(p, os.path.join(out_dir, ex))

    print("Icons extracted to", out_dir)

if __name__ == "__main__":
    main()