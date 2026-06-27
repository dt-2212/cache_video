import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';

@freezed
abstract class Video with _$Video {
  const factory Video({
    required String id,
    required String url,
    required String title,
    required String category,
    required String author,
    required String caption,
    required String music,
    required int likes,
    required int comments,
    required int shares,
    required int views,
    required Color thumbColor,
    String? logoUrl,
    @Default(false) bool isLive,
  }) = _Video;

  const Video._();

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
