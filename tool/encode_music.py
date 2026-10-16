"""Encodes build/audio/music_*.wav to assets/audio/music_*.ogg (Ogg Vorbis).

Dev-only step after `dart run tool/generate_audio.dart`:

    python -m pip install --user soundfile numpy
    python tool/encode_music.py

Stereo Ogg keeps the loop around 1 MB instead of ~11 MB of WAV. Vorbis
loops cleanly in flutter_soloud (no MP3-style encoder padding at the seam).
"""
import glob
import os

import soundfile as sf

for src in sorted(glob.glob('build/audio/music_*.wav')):
    data, rate = sf.read(src, dtype='float32')
    dst = os.path.join('assets', 'audio', os.path.basename(src)[:-4] + '.ogg')
    # libsndfile's Vorbis writer crashes on one huge write: feed it in blocks.
    with sf.SoundFile(dst, 'w', rate, data.shape[1], format='OGG', subtype='VORBIS',
                      compression_level=0.45) as f:  # ~ Vorbis q5
        for i in range(0, len(data), 4096):
            f.write(data[i:i + 4096])
    print(f'{dst}: {len(data) / rate:.2f}s, {os.path.getsize(dst) / 1024:.0f} KB')
