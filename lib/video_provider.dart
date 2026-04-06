import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_provider.g.dart';

@riverpod
List<String> videoUrls(VideoUrlsRef ref) {
  return [
   'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
   'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8',
   'https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8',
   'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8'
  ];
}

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build() => 0;

  void set(int index) {
    state = index;
  }
}
