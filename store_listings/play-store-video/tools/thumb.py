"""YouTube thumbnail: the Play feature graphic resized to 1280x720.

The feature graphic itself is never changed. It is scaled to 1280 wide and
centred on a blurred copy of itself, with soft top and bottom edges.
Usage: python thumb.py
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[3]
SRC = ROOT / "assets" / "brand" / "feature-graphic-1024x500.png"
OUT = Path(__file__).resolve().parents[1] / "youtube-thumbnail-1280x720.png"
W, H = 1280, 720
FEATHER = 60

src = Image.open(SRC).convert("RGB")
scaled = src.resize((W, round(src.height * W / src.width)), Image.LANCZOS)  # 1280x625
top = (H - scaled.height) // 2

# Background: the art's own colour (its top-left blueprint blue), blurred so
# nothing reads as a hard band.
bg_colour = src.getpixel((8, 8))
base = Image.new("RGB", (W, H), bg_colour)
blur = scaled.filter(ImageFilter.GaussianBlur(60)).resize((W, H), Image.LANCZOS)
base = Image.blend(base, blur, 0.5)

mask = Image.new("L", scaled.size, 255)
md = ImageDraw.Draw(mask)
for i in range(FEATHER):
    a = round(255 * (i / FEATHER) ** 1.3)
    md.line([(0, i), (W, i)], fill=a)
    md.line([(0, scaled.height - 1 - i), (W, scaled.height - 1 - i)], fill=a)
base.paste(scaled, (0, top), mask)
base.save(OUT, optimize=True)
print(OUT, base.size)
