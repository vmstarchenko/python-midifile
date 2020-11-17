import os
from midifile import MidiFile
import json
import collections
import argparse


def get_meta(path):
    mid = MidiFile(path)

    if not mid.status():
        return

    meta = {
        'tpq': mid.get_ticks_per_quarter_note(),
        'tracks': mid.get_track_count(),
        'texts': [],
        'lyric_texts': [],
        'track_names': [],
    }

    percussion_found = False
    meta['event_count'] = mid[0].get_event_count()
    instruments = collections.defaultdict(set)
    for track_idx, track in enumerate(mid):
        for msg in track:
            if msg.is_lyric_text():
                meta['lyric_texts'].append(msg.get_meta_content().decode())
            elif msg.is_text():
                meta['texts'].append(msg.get_meta_content().decode())

            elif msg.is_track_name():
                meta['track_names'].append(msg.get_meta_content().decode())
            elif msg.is_note():
                channel = msg.get_channel_nibble()
                if channel == 9:
                    percussion_found = True
            elif msg.is_timbre():
                instruments[track_idx].add(msg.get_p1())

    meta['has_percussion'] = percussion_found
    meta['instruments'] = {k: sorted(v) for k, v in instruments.items()}
    return meta


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('path')
    return parser.parse_args()


def main():
    args = parse_args()
    meta = get_meta(args.path)
    print(json.dumps(meta, indent=4, sort_keys=True))


if __name__ == '__main__':
    main()
