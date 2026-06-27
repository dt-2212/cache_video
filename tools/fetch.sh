#!/usr/bin/env bash
#
# fetch.sh — Master script tải video nguồn về kho (hỗ trợ Archive.org, Pexels & yt-dlp).
#
# Dùng:
#   ./tools/fetch.sh                        # Tải kho phim mẫu mặc định (Archive.org)
#   ./tools/fetch.sh "https://youtu.be/..."  # Tải theo URL YouTube/Vimeo (tối đa 720p, <20p)
#   ./tools/fetch.sh -f tools/urls.txt      # Tải danh sách từ file text
#   PEXELS_API_KEY=xxx ./tools/fetch.sh     # + Tải clip ngắn Pexels
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KHO_DIR="${KHO_DIR:-$SCRIPT_DIR/../../cache_video_kho}"
SRC="$KHO_DIR/source"
FILMS_DIR="$SRC/films"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
mkdir -p "$FILMS_DIR"

echo "📦 Kho nguồn: $SRC"

# ── Xử lý URL tùy chọn via yt-dlp ───────────────────────────────────────────
if [ "$#" -gt 0 ]; then
  if ! python3 -m yt_dlp --version >/dev/null 2>&1; then
    echo "📦 Đang cài đặt yt-dlp..."
    pip3 install --user yt-dlp >/dev/null 2>&1 || brew install yt-dlp
  fi
  DL_OPTS=(
    --extractor-args "youtube:player_client=android"
    --match-filter "duration <= 1200"
    -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best[height<=720]"
    --merge-output-format mp4
    -o "$FILMS_DIR/%(title)s.%(ext)s"
    --no-playlist
  )
  if [ "$1" = "-f" ] && [ -f "${2:-}" ]; then
    echo "⬇️  Đang tải danh sách từ $2..."
    python3 -m yt_dlp "${DL_OPTS[@]}" -a "$2"
  else
    echo "⬇️  Đang tải các URL được cung cấp..."
    python3 -m yt_dlp "${DL_OPTS[@]}" "$@"
  fi
  exit 0
fi

# ── Hàm trợ giúp tải file qua curl ───────────────────────────────────────────
dl_list() {
  while IFS=$'\t' read -r url out; do
    [ -z "$url" ] && continue
    if [ -s "$out" ]; then echo "   ✓ $(basename "$out")"; continue; fi
    mkdir -p "$(dirname "$out")"
    echo "   • $(basename "$out")"
    curl -fsSL --max-time 1200 -A "$UA" "$url" -o "$out" || { echo "   ⚠ lỗi"; rm -f "$out"; }
  done
}

# ── 1. Gói phim Blender (Archive.org Sintel_201709) ─────────────────────────
echo "⬇️  Phim Blender (5 phim dài) → films/ …"
curl -fsSL --max-time 40 "https://archive.org/metadata/Sintel_201709" 2>/dev/null \
| DEST="$FILMS_DIR" python3 -c '
import sys, json, os, urllib.parse
try: d = json.load(sys.stdin)
except Exception: sys.exit(0)
dest = os.environ["DEST"]
for f in d.get("files", []):
    name = f.get("name", "")
    if not name.lower().endswith(".mp4"): continue
    out = os.path.join(dest, os.path.basename(name).replace(" ", "_"))
    url = "https://archive.org/download/Sintel_201709/%s" % urllib.parse.quote(name)
    print(url + "\t" + out)
' | dl_list

# ── 2. Gói phim người đóng kinh điển (Archive.org Open Films) ──────────────
echo "⬇️  Phim điện ảnh kinh điển → films/ …"
python3 -c '
import json, os, urllib.parse, urllib.request
dest = "'"$FILMS_DIR"'"
items = [
    ("TheImmigrant1917", "The_Immigrant_Chaplin.mp4"),
    ("OneWeek1920", "One_Week_Buster_Keaton.mp4"),
    ("EasyStreet1917", "Easy_Street_Chaplin.mp4"),
    ("TheAdventurer1917", "The_Adventurer_Chaplin.mp4"),
    ("TheCount1916", "The_Count_Chaplin.mp4"),
    ("ThePawnshop1916", "The_Pawnshop_Chaplin.mp4"),
]
for item_id, out_name in items:
    out_path = os.path.join(dest, out_name)
    if os.path.exists(out_path) and os.path.getsize(out_path) > 1000000:
        print(f"   ✓ {out_name}")
        continue
    try:
        req = urllib.request.urlopen(f"https://archive.org/metadata/{item_id}", timeout=20)
        data = json.loads(req.read().decode())
        files = data.get("files", [])
        mp4 = next((f["name"] for f in files if f.get("name","").endswith(".mp4") and not f.get("name","").endswith("_512kb.mp4")), None)
        if mp4:
            url = f"https://archive.org/download/{item_id}/{urllib.parse.quote(mp4)}"
            print(f"{url}\t{out_path}")
    except Exception: pass
' | dl_list

# ── 3. Clip ngắn Pexels (nếu có API key) ─────────────────────────────────────
if [ -n "${PEXELS_API_KEY:-}" ]; then
  PEXELS_CATS=("thien-nhien:nature" "phong-canh:landscape" "dai-duong:ocean" "thanh-pho:city" "hanh-dong:action")
  PER="${PEXELS_PER:-10}"
  echo "⬇️  Pexels → feed (${#PEXELS_CATS[@]} category × $PER)…"
  for entry in "${PEXELS_CATS[@]}"; do
    cat="${entry%%:*}"; query="${entry##*:}"
    curl -fsSL -H "Authorization: $PEXELS_API_KEY" -G "https://api.pexels.com/videos/search" \
      --data-urlencode "query=$query" --data-urlencode "per_page=$PER" --data-urlencode "orientation=portrait" 2>/dev/null \
    | DEST="$SRC/feed/$cat" python3 -c '
import sys, json, os
try: d = json.load(sys.stdin)
except Exception: sys.exit(0)
dest = os.environ["DEST"]
for v in d.get("videos", []):
    files = sorted(v["video_files"], key=lambda f: (f.get("height") or 0))
    if files: print(files[len(files)//2]["link"] + "\t" + os.path.join(dest, "pexels-%s.mp4" % v["id"]))
' | dl_list
  done
fi

echo "✅ Hoàn tất."
echo "   films: $(find "$SRC/films" -type f -iname '*.mp4' 2>/dev/null | wc -l | tr -d ' ') video"
echo "   feed : $(find "$SRC/feed" -iname '*.mp4' 2>/dev/null | wc -l | tr -d ' ') clip"
