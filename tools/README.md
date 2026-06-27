# tools/ — Bộ công cụ dựng kho video HLS VOD

Bộ công cụ thu gọn hỗ trợ toàn bộ quy trình: Tải video ➔ Nén & Cắt tập HLS VOD ➔ Sinh catalog.json cho ứng dụng Flutter.

## Cấu trúc thư mục tools/ (3 file chính)
- **`fetch.sh`**: Script tải video thông minh (tải phim mẫu Archive.org, clip Pexels, hoặc tải bất kỳ URL YouTube/Vimeo nào <20p chuẩn 720p).
- **`transcode.sh`**: Chuyển đổi toàn bộ video trong kho nguồn thành chuẩn luồng phát HLS VOD 720p.
- **`build_catalog.py`**: Quét toàn bộ kho HLS và xuất ra tệp `assets/catalog.json` chuẩn cho ứng dụng Flutter.

## Quy trình 3 bước sử dụng:

```bash
# 1. Tải video về kho nguồn:
./tools/fetch.sh                        # Tải phim mẫu Archive.org mặc định
./tools/fetch.sh "URL_YOUTUBE"          # Tải video từ YouTube (<20 phút, 720p)
./tools/fetch.sh -f tools/urls.txt      # Tải danh sách từ file text

# 2. Convert HLS VOD (cắt tập ~1p cho phim dài):
./tools/transcode.sh

# 3. Sinh catalog.json cho ứng dụng:
python3 tools/build_catalog.py
BASE_URL=https://your-domain.com python3 tools/build_catalog.py # với URL host thật
```
