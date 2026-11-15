"""Screw Out Play Store promo video, LANDSCAPE 1920x1080, light frame.

Captions on the left of a light blueprint-paper background, the phone
recording on the right. Usage:
    python render_landscape.py <ffmpeg.exe> <scenes.json> <music> <out.mp4>
"""

import json
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

D = Path(__file__).parent
APP = D.parents[2]
FF, SCENES, MUSIC, OUT = sys.argv[1:5]
W, H = 1920, 1080

PAPER = (243, 247, 252)
GRID = (30, 75, 126)
INK = (15, 42, 77)
SUB = (74, 99, 133)
BLUE = (30, 75, 126)
YELLOW = (242, 193, 78)
GREEN = (60, 160, 120)

INTRO, OUTRO, FADE = 3.0, 4.5, 0.3

PH = 980
PW = round(PH * 1080 / 2340 / 2) * 2
PX, PY = 1250, (H - PH) // 2
RADIUS = 40
CAP_X, CAP_W = 150, 960

CHIPS = {"yellow": (YELLOW, INK), "blue": (BLUE, (255, 255, 255)), "green": (GREEN, (255, 255, 255))}


def grotesk(size, weight=700):
    f = ImageFont.truetype(str(APP / "assets" / "fonts" / "SpaceGrotesk-Variable.ttf"), size)
    f.set_variation_by_axes([weight])
    return f


def mono(size, weight=500):
    f = ImageFont.truetype(str(APP / "assets" / "fonts" / "JetBrainsMono-Variable.ttf"), size)
    f.set_variation_by_axes([weight])
    return f


def wrap(draw, text, f, width):
    lines, cur = [], ""
    for word in text.split():
        trial = f"{cur} {word}".strip()
        if draw.textlength(trial, font=f) <= width:
            cur = trial
        else:
            lines.append(cur)
            cur = word
    return lines + [cur]


def spaced(draw, xy, text, f, fill, spacing, anchor="lm"):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=f, fill=fill, anchor=anchor)
        x += draw.textlength(ch, font=f) + spacing
    return x


def spaced_width(draw, text, f, spacing):
    return sum(draw.textlength(c, font=f) + spacing for c in text) - spacing


def centered_spaced(d, cx, y, text, f, fill, spacing):
    spaced(d, (cx - spaced_width(d, text, f, spacing) / 2, y), text, f, fill, spacing)


def chip(draw, x, y, label, color):
    bg, fg = CHIPS.get(color, CHIPS["yellow"])
    f = mono(30, 800)
    tw = spaced_width(draw, label, f, 6)
    h = 62
    draw.rectangle((x, y, x + tw + 52, y + h), fill=bg)
    spaced(draw, (x + 26, y + h / 2), label, f, fg, 6)
    return y + h


def caption_png(i, s):
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    ft, fs = grotesk(92, 700), grotesk(44, 400)
    tlines = wrap(d, s["title"], ft, CAP_W)
    slines = wrap(d, s["sub"], fs, CAP_W - 60)[:3]
    block = 62 + 44 + len(tlines) * 104 + 26 + len(slines) * 60
    y = (H - block) // 2
    y = chip(d, CAP_X, y, s["chip"], s.get("color", "yellow")) + 44
    for line in tlines:
        d.text((CAP_X - 4, y), line, font=ft, fill=INK)
        y += 104
    y += 26
    for line in slines:
        d.text((CAP_X, y), line, font=fs, fill=SUB)
        y += 60
    p = D / f"lcap{i}.png"
    img.save(p)
    return p


def background():
    img = Image.new("RGB", (W, H), PAPER)
    d = ImageDraw.Draw(img, "RGBA")
    for step, alpha in ((24, 14), (120, 34)):
        for x in range(0, W, step):
            d.line([(x, 0), (x, H)], fill=(*GRID, alpha), width=1)
        for y in range(0, H, step):
            d.line([(0, y), (W, y)], fill=(*GRID, alpha), width=1)
    return img


def phone_assets():
    bg = background()
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (PX - 4, PY + 14, PX + PW + 4, PY + PH + 26), radius=RADIUS + 10, fill=(15, 42, 77, 90))
    shadow = shadow.filter(ImageFilter.GaussianBlur(28))
    bg.paste(shadow, (0, 0), shadow)
    ImageDraw.Draw(bg).rounded_rectangle(
        (PX - 10, PY - 10, PX + PW + 9, PY + PH + 9), radius=RADIUS + 10, fill=INK)
    bg.save(D / "lstage.png")
    mask = Image.new("L", (PW, PH), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, PW - 1, PH - 1), radius=RADIUS, fill=255)
    mask.save(D / "lmask.png")


def logo(size):
    return Image.open(APP / "assets" / "brand" / "logomark-on-light-512.png").convert("RGBA").resize(
        (size, size), Image.LANCZOS)


def card(name, build):
    img = background()
    build(img, ImageDraw.Draw(img))
    p = D / f"{name}.png"
    img.save(p)
    return p


def intro(img, d):
    lg = logo(240)
    img.paste(lg, ((W - 240) // 2, 230), lg)
    d.text((W / 2, 610), "Screw Out.", font=grotesk(168, 700), fill=INK, anchor="mm")
    centered_spaced(d, W / 2, 750, "A PUZZLE OF LAYERS", mono(40, 600), SUB, 10)
    centered_spaced(d, W / 2, 820, "UNSCREW · RELEASE · CLEAR", mono(34, 700), BLUE, 8)


def outro(img, d):
    lg = logo(170)
    img.paste(lg, (180, 160), lg)
    d.text((380, 245), "Screw Out.", font=grotesk(120, 700), fill=INK, anchor="lm")
    items = ["100 sheets, 5 chapters", "A fresh daily puzzle", "Hints when you need them",
             "Collectable board themes"]
    fi = grotesk(52, 500)
    y = 470
    for t in items:
        d.rectangle((190, y, 226, y + 36), fill=YELLOW)
        d.text((262, y + 18), t, font=fi, fill=INK, anchor="lm")
        y += 100
    bw, bh, bx, by = 620, 150, 1150, 410
    d.rectangle((bx + 10, by + 10, bx + bw + 10, by + bh + 10), fill=INK)
    d.rectangle((bx, by, bx + bw, by + bh), fill=YELLOW)
    centered_spaced(d, bx + bw / 2, by + bh / 2, "PLAY NOW", grotesk(66, 700), INK, 6)
    centered_spaced(d, bx + bw / 2 + 5, by + bh + 80, "ON GOOGLE PLAY", mono(38, 700), SUB, 9)


def main():
    scenes = json.loads(Path(SCENES).read_text(encoding="utf-8"))["segments"]
    phone_assets()
    caps = [caption_png(i, s) for i, s in enumerate(scenes)]
    intro_p, outro_p = card("lintro", intro), card("loutro", outro)

    durs = [s["b"] - s["a"] for s in scenes]
    demo_len = sum(durs)
    total = INTRO + demo_len + OUTRO

    srcs = sorted({s["src"] for s in scenes})
    inputs, idx = [], {}
    for sp in srcs:
        idx[sp] = len(inputs) // 2
        inputs += ["-i", str(D / sp)]
    n_src = len(srcs)
    inputs += ["-loop", "1", "-i", str(D / "lstage.png")]
    inputs += ["-i", str(D / "lmask.png")]
    inputs += ["-loop", "1", "-t", str(INTRO), "-i", str(intro_p)]
    inputs += ["-loop", "1", "-t", str(OUTRO), "-i", str(outro_p)]
    cap0 = n_src + 4
    for p, du in zip(caps, durs):
        inputs += ["-loop", "1", "-t", f"{du:.3f}", "-i", str(p)]
    music_i = cap0 + len(scenes)
    inputs += ["-stream_loop", "-1", "-i", MUSIC]

    fc = []
    uses = {sp: [i for i, s in enumerate(scenes) if s["src"] == sp] for sp in srcs}
    for sp, ids in uses.items():
        k = idx[sp]
        outs = "".join(f"[r{i}]" for i in ids)
        fc.append(f"[{k}:v]fps=30,split={len(ids)}{outs}" if len(ids) > 1 else f"[{k}:v]fps=30{outs}")
    for i, s in enumerate(scenes):
        fc.append(f"[r{i}]trim={s['a']}:{s['b']},setpts=PTS-STARTPTS[t{i}]")
    fc.append("".join(f"[t{i}]" for i in range(len(scenes))) + f"concat=n={len(scenes)}:v=1:a=0[rec]")
    fc.append(f"[rec]scale={PW}:{PH}:flags=lanczos,format=rgba[ph]")
    fc.append(f"[{n_src + 1}:v]format=gray[mk]")
    fc.append("[ph][mk]alphamerge[phr]")
    fc.append(f"[{n_src}:v]fps=30,trim=0:{demo_len:.3f},setpts=PTS-STARTPTS[stg]")
    fc.append(f"[stg][phr]overlay={PX}:{PY}:shortest=1[a0]")
    last, t = "a0", 0.0
    for i, du in enumerate(durs):
        fades = f"fade=in:st=0:d={FADE}:alpha=1,fade=out:st={du - FADE:.3f}:d={FADE}:alpha=1"
        fc.append(f"[{cap0 + i}:v]format=rgba,{fades},setpts=PTS-STARTPTS+{t:.3f}/TB[c{i}]")
        fc.append(f"[{last}][c{i}]overlay=0:0:eof_action=pass[b{i}]")
        last, t = f"b{i}", t + du
    fc.append(f"color=c=0xF2C14E:s={W}x8:r=30:d={demo_len:.3f}[bar]")
    fc.append(f"[{last}][bar]overlay=x='-{W}+{W}*t/{demo_len:.3f}':y={H - 8}:shortest=1,"
              f"format=yuv420p,setsar=1[demo]")
    fc.append(f"[{n_src + 2}:v]fps=30,format=yuv420p,fade=in:st=0:d=0.35:c=white,"
              f"fade=out:st={INTRO - 0.35}:d=0.35:c=white,setsar=1[in]")
    fc.append(f"[{n_src + 3}:v]fps=30,format=yuv420p,fade=in:st=0:d=0.35:c=white,"
              f"fade=out:st={OUTRO - 0.6}:d=0.6:c=white,setsar=1[out]")
    fc.append("[in][demo][out]concat=n=3:v=1:a=0[v]")
    fc.append(f"[{music_i}:a]atrim=0:{total:.3f},asetpts=PTS-STARTPTS,volume=0.8,"
              f"afade=in:st=0:d=0.6,afade=out:st={total - 1.8:.3f}:d=1.8[aud]")

    cmd = [FF, "-hide_banner", "-loglevel", "error", "-y", *inputs, "-filter_complex", ";".join(fc),
           "-map", "[v]", "-map", "[aud]", "-t", f"{total:.2f}", "-c:v", "libx264", "-crf", "19",
           "-preset", "slow", "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "192k",
           "-movflags", "+faststart", OUT]
    subprocess.run(cmd, check=True)
    print("done", round(total, 2))


main()
