"""Checks listings.json against App Store Connect limits and the 4.3 rules in SOURCE.md.

Run: python3 store_listings/app-store-i18n/check.py
"""
import json
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).parent
LIMITS = {"name": 30, "subtitle": 30, "keywords": 100, "promotionalText": 170, "description": 4000}
# Genre words App Review flagged under 4.3 (English plus the obvious cognates).
BANNED = re.compile(r"\b(nuts?|bolts?|pins?|jam|sort|screw puzzle)\b", re.I)
URLS = [
    "https://legal.pranta.dev/privacy/html?projectName=screw_out",
    "https://legal.pranta.dev/terms/html?projectName=screw_out",
]

data = json.loads((HERE / "listings.json").read_text(encoding="utf-8"))
problems = []
for loc, f in data.items():
    for field, limit in LIMITS.items():
        value = f.get(field, "")
        if not value:
            problems.append(f"{loc}: {field} missing")
            continue
        if len(value) > limit:
            problems.append(f"{loc}: {field} is {len(value)} > {limit}")
        if "–" in value or "—" in value:
            problems.append(f"{loc}: {field} has an en/em dash")
    for field in ("name", "subtitle", "keywords"):
        if BANNED.search(f.get(field, "")):
            problems.append(f"{loc}: {field} uses a banned genre word")
    kw = f.get("keywords", "")
    if ", " in kw:
        problems.append(f"{loc}: keywords have spaces after commas")
    if not f.get("name", "").startswith("Screw Out"):
        problems.append(f"{loc}: name must start with 'Screw Out'")
    for url in URLS:
        if url not in f.get("description", ""):
            problems.append(f"{loc}: description lost {url}")

for loc, f in data.items():
    print(f"{loc:8} name {len(f.get('name','')):2} sub {len(f.get('subtitle','')):2} "
          f"kw {len(f.get('keywords','')):3} promo {len(f.get('promotionalText','')):3} "
          f"desc {len(f.get('description','')):4}")
print("\n".join(problems) or "OK")
sys.exit(1 if problems else 0)
