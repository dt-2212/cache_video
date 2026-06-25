/// A remote playlist the app pulls live channels from.
///
/// Sources are described generically — a title plus a playlist URL — so the
/// underlying provider can be swapped without touching the rest of the app.
/// To change where channels come from, edit [channelSources] only; the UI and
/// services know nothing about the provider behind a source.
class ChannelSource {
  /// Rail title when [splitByGroup] is false, and the fallback group name for
  /// channels that carry no `group-title`.
  final String title;

  /// Extended-M3U / M3U8 playlist URL.
  final String url;

  /// When true, the playlist is split into one rail per `group-title`
  /// (a big mixed playlist becomes several themed rails). When false, the whole
  /// playlist becomes a single rail named [title].
  final bool splitByGroup;

  /// Max channels kept per rail before validation prunes the dead ones.
  final int limitPerRail;

  /// Max rails produced when [splitByGroup] is true (keeps the Home page from
  /// exploding into dozens of rails). Ignored when [splitByGroup] is false.
  final int maxRails;

  const ChannelSource({
    required this.title,
    required this.url,
    this.splitByGroup = false,
    this.limitPerRail = 20,
    this.maxRails = 8,
  });
}

/// The active channel sources, in display order.
///
/// Swap these freely — the rest of the app only deals in rails of channels, not
/// where they came from. These default to free, ad-supported (FAST) and
/// free-to-air providers, which are far more stable than community-aggregated
/// lists. Validation in the service still prunes anything that fails to play
/// (e.g. region-locked streams), so a heavier source list is safe.
const List<ChannelSource> channelSources = [
  // One large mixed playlist that already carries useful `group-title` buckets
  // (News, Movies, Sports, Kids, …) → split into one themed rail each.
  ChannelSource(
    title: 'Live TV',
    url: 'https://raw.githubusercontent.com/BuddyChewChew/app-m3u-generator/main/playlists/plutotv_us.m3u',
    splitByGroup: true,
    limitPerRail: 15,
    maxRails: 8,
  ),
  // Curated single-theme playlists, one rail each.
  ChannelSource(
    title: 'World News',
    url: 'https://raw.githubusercontent.com/Free-TV/IPTV/master/playlists/playlist_zz_news_en.m3u8',
    limitPerRail: 20,
  ),
  ChannelSource(
    title: 'Movies',
    url: 'https://raw.githubusercontent.com/Free-TV/IPTV/master/playlists/playlist_zz_movies.m3u8',
    limitPerRail: 20,
  ),
  ChannelSource(
    title: 'Documentary',
    url: 'https://raw.githubusercontent.com/Free-TV/IPTV/master/playlists/playlist_zz_documentaries_en.m3u8',
    limitPerRail: 20,
  ),
];
