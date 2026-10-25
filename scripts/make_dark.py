import os

script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(script_dir, ".."))
src = os.path.join(project_root, "chrome", "RetroFox2004", "theme.css")
dst = os.path.join(project_root, "chrome", "RetroFox2004", "theme-dark.css")

text = open(src, encoding="utf-8").read()

repls = [
 ("color-scheme: light", "color-scheme: dark"),
 ("#ece9d8", "#1e1e1e"),
 ("#faf9f3", "#2a2a2a"),
 ("#e8e5d9", "#222222"),
 ("#fcfbf6", "#2a2a2a"),
 ("#ece9df", "#252525"),
 ("#e0ddd0", "#1f1f1f"),
 ("#ffffff", "#2a2a2a"),
 ("#fff", "#2a2a2a"),
 ("#d9eafc", "#333333"),
 ("#c8ddf2", "#2f2f2f"),
 ("#202020", "#e0e0e0"),
 ("#222222", "#e0e0e0"),
 ("#fdfcf8", "#2a2a2a"),
 ("#f5f4ed", "#222222"),
 ("#dad7cd", "#1a1a1a"),
 ("#f9f8f1", "#2f2f2f"),
 ("#aba99e", "#444444"),
 ("#c8c5b8", "#444444"),
 ("#bebbae", "#444444"),
 ("#b5b1a5", "#444444"),
 ("#a5a6a2", "#555555"),
 ("#8799ae", "#555555"),
 ("#889aae", "#555555"),
 ("#8f9cae", "#555555"),
 ("#547fb4", "#6fa3d9"),
 ("#b9d3ed", "#3a5a7a"),
 ("#d1d1d1", "#444444"),
 ("#dce9fa", "#333333"),
 ("#dceafa", "#333333"),
 ("#e8f2ff", "#2f2f2f"),
 ("#bbd5f2", "#2f2f2f"),
 ("#7093bc", "#555555"),
 ("#8dadcf", "#555555"),
 ("#8fa8c6", "#555555"),
 ("#3a5a7a", "#333333"),
 ("#6fa3d9", "#555555"),
 ("#354252", "#333333"),
 ("#3f4b5b", "#333333"),
 ("#e7e3d6", "#222222"),
]
for a,b in repls:
    text = text.replace(a,b)

text = text.replace("RetroFox 2004 - Genuine Winstripe theme", "RetroFox 2004 Dark Edition - Genuine Winstripe theme")
# Fix PersonalToolbar gradient being clobbered by text-color replacement
text = text.replace("linear-gradient(#2a2a2a, #e0e0e0)", "linear-gradient(#2a2a2a, #222222)")
text = text.replace(
"#PersonalToolbar {\n  background: linear-gradient(#2a2a2a, #222222) !important;\n  color: #e0e0e0 !important;\n}",
"#PersonalToolbar {\n  background: linear-gradient(#2a2a2a, #222222) !important;\n  color: #e0e0e0 !important;\n  border-bottom: 1px solid #444444 !important;\n}")
text = text.replace(
"#PersonalToolbar .toolbarbutton-1:hover {\n  background: #333333 !important;\n  border-radius: 2px !important;\n}",
"#PersonalToolbar .toolbarbutton-1:hover {\n  background: #333333 !important;\n  border-radius: 2px !important;\n}\n#PersonalToolbar .toolbarseparator {\n  background: #444444 !important;\n  border-color: #444444 !important;\n}")
# urlbar field darker
text = text.replace("background: #2a2a2a !important;\n  box-shadow: inset 0 1px 1px #444444 !important;", "background: #1a1a1a !important;\n  box-shadow: inset 0 1px 1px #111111 !important;")

open(dst, "w", encoding="utf-8").write(text)
print("written dark theme")