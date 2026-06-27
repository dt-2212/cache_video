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
    required Color thumbColor,
    String? logoUrl,
    @Default(false) bool isLive,
  }) = _Video;
}
