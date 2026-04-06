// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoUrlsHash() => r'43d5774266a6fde4716e2cb81a77669576ae7d0f';

/// See also [videoUrls].
@ProviderFor(videoUrls)
final videoUrlsProvider = AutoDisposeProvider<List<String>>.internal(
  videoUrls,
  name: r'videoUrlsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$videoUrlsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VideoUrlsRef = AutoDisposeProviderRef<List<String>>;
String _$currentIndexHash() => r'c7fbb951af2ca85fd45bcabfb62d6cbe36dd4ec8';

/// See also [CurrentIndex].
@ProviderFor(CurrentIndex)
final currentIndexProvider =
    AutoDisposeNotifierProvider<CurrentIndex, int>.internal(
  CurrentIndex.new,
  name: r'currentIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
