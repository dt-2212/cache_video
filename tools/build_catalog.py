#!/usr/bin/env python3
"""build_catalog.py — Quét kho/hls → assets/catalog.json.

Cấu trúc kho:
    hls/series/<phim>/ep01/index.m3u8   → series nhiều tập (Home)
    hls/feed/<category>/<slug>/index.m3u8 → clip ngắn (Reel feed)

Dùng:
    BASE_URL=https://hls-video.pages.dev python3 tools/build_catalog.py
    BASE_URL=http://192.168.1.10:8080 python3 tools/build_catalog.py   # demo LAN
"""
import json
import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
KHO_DIR = os.environ.get("KHO_DIR", os.path.join(SCRIPT_DIR, "..", "..", "cache_video_kho"))
HLS_DIR = os.path.join(KHO_DIR, "hls")
OUT = os.path.join(SCRIPT_DIR, "..", "assets", "catalog.json")
BASE_URL = os.environ.get("BASE_URL", "https://YOUR-PROJECT.pages.dev").rstrip("/")

CATEGORY_NAMES = {
    "thien-nhien": "Nature", "phong-canh": "Landscape",
    "dai-duong": "Ocean", "thanh-pho": "City",
    "hanh-dong": "Action", "am-nhac": "Music", "khac": "Other",
}


def pretty(slug: str) -> str:
    return slug.replace("-", " ").strip().title()


def has_m3u8(d: str) -> bool:
    return os.path.isfile(os.path.join(d, "index.m3u8"))


def build_series() -> list:
    base = os.path.join(HLS_DIR, "series")
    out = []
    if not os.path.isdir(base):
        return out
    for slug in sorted(os.listdir(base)):
        sdir = os.path.join(base, slug)
        if not os.path.isdir(sdir):
            continue
        eps = []
        for ep in sorted(os.listdir(sdir)):
            epdir = os.path.join(sdir, ep)
            if has_m3u8(epdir):
                eps.append({
                    "ep": len(eps) + 1,
                    "title": f"Episode {len(eps) + 1}",
                    "url": f"{BASE_URL}/series/{slug}/{ep}/index.m3u8",
                })
        if eps:
            out.append({"slug": slug, "title": pretty(slug),
                        "episodeCount": len(eps), "episodes": eps})
    return out


def build_feed() -> list:
    base = os.path.join(HLS_DIR, "feed")
    out = []
    if not os.path.isdir(base):
        return out
    for cat in sorted(os.listdir(base)):
        cdir = os.path.join(base, cat)
        if not os.path.isdir(cdir):
            continue
        vids = []
        for slug in sorted(os.listdir(cdir)):
            if has_m3u8(os.path.join(cdir, slug)):
                vids.append({"id": f"{cat}/{slug}", "title": pretty(slug),
                             "url": f"{BASE_URL}/feed/{cat}/{slug}/index.m3u8"})
        if vids:
            out.append({"slug": cat, "name": CATEGORY_NAMES.get(cat, pretty(cat)),
                        "videos": vids})
    return out


def main() -> int:
    if not os.path.isdir(HLS_DIR):
        print(f"❌ Không thấy {HLS_DIR}. Chạy transcode.sh trước.")
        return 1
    series, feed = build_series(), build_feed()
    catalog = {"baseUrl": BASE_URL, "series": series, "feed": feed}
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(catalog, f, ensure_ascii=False, indent=2)

    nep = sum(s["episodeCount"] for s in series)
    nclip = sum(len(c["videos"]) for c in feed)
    print(f"✅ {len(series)} series ({nep} tập) + {len(feed)} category ({nclip} clip) → {os.path.relpath(OUT)}")
    for s in series:
        print(f"   📺 {s['title']:<18} {s['episodeCount']} tập")
    for c in feed:
        print(f"   📱 {c['name']:<18} {len(c['videos'])} clip")
    if BASE_URL.startswith("https://YOUR-PROJECT"):
        print("⚠️  BASE_URL còn placeholder — đặt URL Cloudflare Pages/LAN thật.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
