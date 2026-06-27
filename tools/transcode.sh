#!/usr/bin/env bash
#
# transcode.sh — Sinh HLS VOD cho cả SERIES (Home) lẫn FEED (Reel).
#
#   source/films/<phim>.mp4       → cắt ~EP_SEC giây/tập → hls/series/<phim>/ep01,ep02,…
#   source/feed/<cat>/<clip>.mp4  → 1 HLS                → hls/feed/<cat>/<slug>/
#
# `-hls_playlist_type vod` → #EXT-X-ENDLIST (đúng loại app cache được).
#
# Dùng:
#   ./tools/transcode.sh
#   EP_SEC=90 MAXH=480 CRF=26 ./tools/transcode.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KHO_DIR="${KHO_DIR:-$SCRIPT_DIR/../../cache_video_kho}"
SRC="$KHO_DIR/source"
OUT="$KHO_DIR/hls"
MAXH="${MAXH:-720}"
CRF="${CRF:-23}"
EP_SEC="${EP_SEC:-60}"      # độ dài mỗi tập (giây) ~1 phút
mkdir -p "$OUT"
command -v ffmpeg >/dev/null 2>&1 || { echo "❌ Cần ffmpeg (brew install ffmpeg)"; exit 1; }

slugify() { basename "${1%.*}" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'; }

# Transcode 1 file → 1 thư mục HLS VOD.
to_hls() {  # $1=input  $2=outdir
  mkdir -p "$2"
  ffmpeg -y -nostdin -loglevel error -i "$1" \
    -vf "scale='min(iw,trunc(${MAXH}*iw/ih/2)*2)':'min(ih,${MAXH})'" \
    -c:v libx264 -preset veryfast -crf "$CRF" -c:a aac -b:a 128k \
    -hls_time 6 -hls_playlist_type vod \
    -hls_segment_filename "$2/seg_%03d.ts" "$2/index.m3u8"
}

# ── SERIES: cắt mỗi phim thành tập ~EP_SEC giây ──────────────────────────────
if [ -d "$SRC/films" ]; then
  echo "📺 SERIES (cắt ~${EP_SEC}s/tập):"
  while IFS= read -r -d '' film; do
    slug="$(slugify "$film")"
    sdir="$OUT/series/$slug"
    if [ -d "$sdir" ] && [ -n "$(ls -A "$sdir" 2>/dev/null)" ]; then echo "  ✓ bỏ qua: $slug"; continue; fi
    echo "  🎬 $slug — đang cắt…"
    tmp="$(mktemp -d)"
    # Cắt giữ nguyên codec vào segment .mkv (nhận cả vp9/opus của webm).
    ffmpeg -y -nostdin -loglevel error -i "$film" -map 0:v:0 -map 0:a:0? -c copy \
      -f segment -segment_time "$EP_SEC" -reset_timestamps 1 "$tmp/part_%03d.mkv" 2>/dev/null \
      || { echo "    ⚠ lỗi cắt $slug"; rm -rf "$tmp"; continue; }
    ep=1
    for part in "$tmp"/part_*.mkv; do
      [ -e "$part" ] || continue
      epdir="$sdir/$(printf 'ep%02d' "$ep")"
      to_hls "$part" "$epdir" && echo "    ✅ tập $ep" || echo "    ⚠ lỗi tập $ep"
      ep=$((ep+1))
    done
    rm -rf "$tmp"
  done < <(find "$SRC/films" -maxdepth 1 -type f \( -iname '*.mp4' -o -iname '*.mov' -o -iname '*.mkv' -o -iname '*.webm' -o -iname '*.ogv' \) -print0)
fi

# ── FEED: mỗi clip → 1 HLS, giữ category ─────────────────────────────────────
if [ -d "$SRC/feed" ]; then
  echo "📱 FEED (clip theo category):"
  while IFS= read -r -d '' f; do
    rel="${f#"$SRC"/feed/}"; cat="${rel%%/*}"
    slug="$(slugify "$f")"; dir="$OUT/feed/$cat/$slug"
    if [ -s "$dir/index.m3u8" ]; then echo "  ✓ bỏ qua: $cat/$slug"; continue; fi
    echo "  🎬 $cat/$slug"
    to_hls "$f" "$dir" && echo "    ✅" || { echo "    ⚠ lỗi"; rm -rf "$dir"; }
  done < <(find "$SRC/feed" -type f -iname '*.mp4' -print0)
fi

echo "✅ Xong. Series: $(find "$OUT/series" -name index.m3u8 2>/dev/null | wc -l | tr -d ' ') tập | Feed: $(find "$OUT/feed" -name index.m3u8 2>/dev/null | wc -l | tr -d ' ') clip"
