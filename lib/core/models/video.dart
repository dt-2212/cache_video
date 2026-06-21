import 'package:flutter/material.dart';

/// A single short video / drama item with the metadata shown across the app.
class Video {
  final String id;
  final String url;
  final String title;
  final String category;
  final String author;
  final String caption;
  final String music;
  final int likes;
  final int comments;
  final int shares;
  final int views;

  /// Accent color used for placeholder thumbnails / gradients.
  final Color thumbColor;

  /// Channel/poster logo (e.g. iptv-org `tvg-logo`). Null falls back to the
  /// gradient placeholder built from [thumbColor].
  final String? logoUrl;

  /// True for live IPTV channels — shows a LIVE badge instead of view counts.
  final bool isLive;

  const Video({
    required this.id,
    required this.url,
    required this.title,
    required this.category,
    required this.author,
    required this.caption,
    required this.music,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.views,
    required this.thumbColor,
    this.logoUrl,
    this.isLive = false,
  });

  String get likesLabel => _compact(likes);
  String get commentsLabel => _compact(comments);
  String get sharesLabel => _compact(shares);
  String get viewsLabel => _compact(views);

  static String _compact(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
