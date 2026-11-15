# Promo video tools

These build `../screw-out-promo-landscape.mp4` (1920x1080, for Play and YouTube) and `../youtube-thumbnail-1280x720.png`. Raw recordings are not committed.

## 1. Record

- Device: the A24 (`RR8W901JDRL`). Other sessions share it: ask before using it, check `pgrep screenrecord`, never restart adb.
- Build the demo APK from the local `demo/autopilot` branch (never merge or push it): `flutter build apk --release --dart-define=DEMO_AUTOPILOT=true`. Levels solve themselves using the hint solver, and ads are off. Reinstall the normal build afterwards.
- Replay already-cleared sheets only (from Sheets, not Continue), so the account's campaign doesn't move.
- `adb shell screenrecord --bit-rate 8000000 --time-limit 178 /sdcard/so_rec1.mp4`, then drive the app with `adb shell input tap`. In Git Bash set `MSYS_NO_PATHCONV=1`, or `/sdcard` gets rewritten. Stop with `pkill -INT screenrecord`.

## 2. Render

```
FF=<python>/site-packages/imageio_ffmpeg/binaries/ffmpeg-win-x86_64-v7.1.exe
python render_landscape.py $FF scenes.json ../music/Carefree.mp3 ../screw-out-promo-landscape.mp4
python thumb.py
```

`scenes.json` holds the cuts (`a`/`b` seconds into the recording) and their captions. The thumbnail is the feature graphic resized; the feature graphic itself is never changed.

## 3. Publish

- Upload to YouTube (public or unlisted, ads off, not made for kids unless that's the target). Put the music credit from `../music/CREDITS.md` in the description.
- Paste the `youtube.com/watch?v=` URL (not `/shorts/`) into Play Console > Main store listing > Video.
