/// A single entry parsed from an M3U / M3U8 playlist (one `#EXTINF` + its URL).
class M3uEntry {
  final String name;
  final String url;
  final String? logo;
  final String? group;
  final String? tvgId;

  const M3uEntry({
    required this.name,
    required this.url,
    this.logo,
    this.group,
    this.tvgId,
  });
}

/// Minimal extended-M3U parser, enough for the iptv-org playlists.
///
/// Reads each `#EXTINF:` line (pulling `tvg-logo`, `group-title`, `tvg-id`
/// attributes and the trailing display name) and pairs it with the next
/// non-comment line, which is the stream URL.
abstract class M3uParser {
  static final RegExp _attr = RegExp(r'([\w-]+)="([^"]*)"');

  static List<M3uEntry> parse(String content) {
    final entries = <M3uEntry>[];
    final lines = content.split('\n');

    String? name;
    Map<String, String> attrs = {};

    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('#EXTINF:')) {
        attrs = {
          for (final m in _attr.allMatches(line)) m.group(1)!: m.group(2)!,
        };
        // Display name is the text after the last comma on the EXTINF line.
        final comma = line.lastIndexOf(',');
        name = comma == -1 ? '' : line.substring(comma + 1).trim();
      } else if (line.startsWith('#')) {
        // Other directives (#EXTM3U, #EXTVLCOPT, ...) are ignored.
        continue;
      } else if (name != null) {
        entries.add(M3uEntry(
          name: name.isEmpty ? (attrs['tvg-id'] ?? 'Channel') : name,
          url: line,
          logo: _clean(attrs['tvg-logo']),
          group: _clean(attrs['group-title']),
          tvgId: _clean(attrs['tvg-id']),
        ));
        name = null;
        attrs = {};
      }
    }
    return entries;
  }

  static String? _clean(String? v) =>
      (v == null || v.trim().isEmpty) ? null : v.trim();
}
