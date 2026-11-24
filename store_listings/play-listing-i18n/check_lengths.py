"""Check the Play listing translations in listings.json.

Prints the length (Unicode characters, Python len) of every field per locale
and fails (exit 1) on:
  - a field over its Play limit
  - an em dash (U+2014), en dash (U+2013) or similar dash in any field
  - a price/promotion word in the title or short description
  - a digit count like "100" in the short description
  - a title that does not start with "Screw Out: "

Run: python check_lengths.py
"""
import json
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent
LIMITS = {"title": 30, "short": 80, "full": 4000, "whatsnew": 500}
EXPECTED = ["en-US", "es-419", "es-ES", "pt-BR", "fr-FR", "de-DE", "ru-RU",
            "tr-TR", "id", "hi-IN", "ar", "bn-BD", "ja-JP", "ko-KR", "zh-TW"]

# U+2012 figure dash, U+2013 en dash, U+2014 em dash, U+2015 horizontal bar,
# U+2E3A/U+2E3B two/three-em dash, U+FE58 small em dash, U+FF0D fullwidth hyphen.
DASHES = {"‒", "–", "—", "―", "⸺", "⸻", "﹘", "－"}

# Matched as whole words (case-insensitive) in scripts with word spacing.
BANNED_WORDS = [
    # English
    "free", "best", "new", "sale", "download now", "top", "discount", "offer",
    # Spanish / Portuguese
    "gratis", "grátis", "gratuito", "gratuita", "mejor", "melhor", "nuevo",
    "nueva", "novo", "nova", "oferta", "descuento", "desconto", "promoción", "promoção",
    # French
    "gratuit", "gratuite", "meilleur", "meilleure", "nouveau", "nouvelle", "soldes", "promo",
    # German
    "kostenlos", "gratis", "beste", "bester", "neu", "neue", "angebot", "rabatt",
    # Russian
    "бесплатно", "бесплатная", "бесплатный", "лучший", "лучшая", "новый", "новая", "скидка",
    # Turkish
    "ücretsiz", "bedava", "en iyi", "yeni", "indirim",
    # Indonesian
    "terbaik", "baru", "diskon",
]
# Matched as substrings (scripts without word spacing, or where \b is unreliable).
BANNED_SUBSTRINGS = [
    "#1", "№1", "№ 1",
    # Hindi
    "मुफ़्त", "मुफ्त", "फ्री", "फ़्री", "सबसे अच्छा", "बेस्ट", "नया", "नई", "सेल",
    # Arabic
    "مجاني", "مجانا", "مجانًا", "أفضل", "جديد", "تخفيض",
    # Bengali
    "ফ্রি", "বিনামূল্যে", "সেরা", "নতুন", "সেল",
    # Japanese
    "無料", "最高", "新作", "新しい", "セール", "ベスト",
    # Korean
    "무료", "최고", "신작", "새로운", "세일", "베스트",
    # Traditional Chinese
    "免費", "最佳", "最好", "新遊戲", "全新", "特價", "優惠",
]


def banned_hits(text):
    hits = []
    low = text.lower()
    for w in BANNED_WORDS:
        if re.search(r"(?<!\w)" + re.escape(w) + r"(?!\w)", low):
            hits.append(w)
    for s in BANNED_SUBSTRINGS:
        if s.lower() in low:
            hits.append(s)
    return hits


def main():
    data = json.loads((HERE / "listings.json").read_text(encoding="utf-8"))
    problems = []

    missing = [k for k in EXPECTED if k not in data]
    extra = [k for k in data if k not in EXPECTED]
    if missing:
        problems.append(f"missing locales: {missing}")
    if extra:
        problems.append(f"unexpected locales: {extra}")

    header = f"{'locale':8} {'title':>5} {'short':>5} {'full':>5} {'new':>4}  title"
    print(header)
    print("-" * len(header))
    for loc, fields in data.items():
        lens = {}
        for f, limit in LIMITS.items():
            text = fields.get(f)
            if not isinstance(text, str) or not text.strip():
                problems.append(f"{loc}.{f}: missing or empty")
                lens[f] = 0
                continue
            lens[f] = len(text)
            if len(text) > limit:
                problems.append(f"{loc}.{f}: {len(text)} > {limit}")
            bad = sorted({c for c in text if c in DASHES})
            if bad:
                problems.append(f"{loc}.{f}: forbidden dash {[hex(ord(c)) for c in bad]}")
        for f in ("title", "short"):
            hits = banned_hits(fields.get(f, ""))
            if hits:
                problems.append(f"{loc}.{f}: banned word(s) {hits}")
        if re.search(r"[0-9०-९০-৯٠-٩]", fields.get("short", "")):
            problems.append(f"{loc}.short: contains a number")
        if not fields.get("title", "").startswith("Screw Out: "):
            problems.append(f"{loc}.title: must start with 'Screw Out: '")
        print(f"{loc:8} {lens['title']:>5} {lens['short']:>5} {lens['full']:>5} "
              f"{lens['whatsnew']:>4}  {fields.get('title', '')}")

    print()
    if problems:
        print(f"FAIL ({len(problems)} problem(s)):")
        for p in problems:
            print("  - " + p)
        return 1
    print(f"PASS: {len(data)} locales, all within limits, no dashes or banned words.")
    return 0


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    sys.exit(main())
