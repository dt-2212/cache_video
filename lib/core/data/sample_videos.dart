import '../models/video.dart';
import '../theme/app_colors.dart';

/// Sample HLS streams reused from the original core, enriched with metadata.
const List<Video> kSampleVideos = [
  Video(
    id: 'v1',
    url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    title: 'Midnight Promise',
    category: 'Romance',
    author: '@official_videos',
    caption: 'Check out this amazing content! #video #trending #foryou',
    music: 'Original Sound - Video Studio',
    likes: 1200000,
    comments: 12500,
    shares: 8900,
    views: 5400000,
    thumbColor: AppColors.accent,
  ),
  Video(
    id: 'v2',
    url:
        'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8',
    title: 'City of Glass',
    category: 'Drama',
    author: '@apple_streams',
    caption: 'Adaptive bitrate magic in action ✨ #tech #hls',
    music: 'Ambient Vibes - Studio Mix',
    likes: 845000,
    comments: 9300,
    shares: 4200,
    views: 3100000,
    thumbColor: AppColors.cyan,
  ),
  Video(
    id: 'v3',
    url:
        'https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8',
    title: 'Neon Hearts',
    category: 'Action',
    author: '@creator_hub',
    caption: 'New drop is live 🔥 tap to watch till the end #fyp',
    music: 'Trending Beat - DJ Loop',
    likes: 562000,
    comments: 7100,
    shares: 3100,
    views: 1800000,
    thumbColor: AppColors.coral,
  ),
  Video(
    id: 'v4',
    url:
        'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
    title: 'Tears of Steel',
    category: 'Sci-Fi',
    author: '@short_films',
    caption: 'Tears of Steel — a sci-fi short 🎬 #cinema #shortfilm',
    music: 'Epic Score - Orchestral',
    likes: 2300000,
    comments: 41000,
    shares: 19000,
    views: 9200000,
    thumbColor: AppColors.mint,
  ),
];
