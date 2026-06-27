import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../../../core/models/video.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/episode_list_sheet.dart';
import '../../../core/widgets/video_feed.dart';

/// Arguments passed to the [FeedViewerScreen] route.
class FeedArgs {
  final List<Video> videos;
  final int initialIndex;

  /// When true, the episode list bottom sheet opens automatically on mount.
  final bool showEpisodesOnOpen;

  const FeedArgs(
    this.videos,
    this.initialIndex, {
    this.showEpisodesOnOpen = false,
  });
}

/// Full-screen vertical feed pushed as its own route (e.g. from Home/Library).
class FeedViewerScreen extends StatefulWidget {
  const FeedViewerScreen({super.key});

  @override
  State<FeedViewerScreen> createState() => _FeedViewerScreenState();
}

class _FeedViewerScreenState extends State<FeedViewerScreen> {
  late final FeedArgs _args;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _args = Get.arguments as FeedArgs;
    _pageController = PageController(initialPage: _args.initialIndex);

    if (_args.showEpisodesOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSheet(_args.initialIndex);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _currentPage =>
      _pageController.hasClients
          ? (_pageController.page?.round() ?? _args.initialIndex)
          : _args.initialIndex;

  void _showSheet(int videoIndex) {
    final i = videoIndex.clamp(0, _args.videos.length - 1);
    showEpisodeListSheet(
      context,
      _args.videos,
      _args.videos[i].thumbColor,
      onEpisodeTap: (epIndex) => _pageController.jumpToPage(epIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          VideoFeed(
            videos: _args.videos,
            initialIndex: _args.initialIndex,
            loop: false,
            controller: _pageController,
            onEpisodesTap: (video) {
              final index = _args.videos.indexOf(video);
              _showSheet(index >= 0 ? index : _currentPage);
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back<void>(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens [videos] as a full-screen vertical feed starting at [index].
void openFeed(
  List<Video> videos,
  int index, {
  bool showEpisodesOnOpen = false,
}) {
  debugPrint('📺 openFeed count=${videos.length} index=$index '
      'first="${videos.isEmpty ? '-' : videos[index].title}"');
  Get.toNamed<void>(
    Routes.feed,
    arguments: FeedArgs(videos, index, showEpisodesOnOpen: showEpisodesOnOpen),
  );
}

/// Opens the full episode list of [video]'s series in the feed.
/// Used from the Reel tab EP button.
void openSeriesFeed(Video video, {bool showEpisodesOnOpen = true}) {
  final data = Get.find<AppDataController>();
  final episodes = data.getEpisodesForSeries(video.author);
  openFeed(episodes, 0, showEpisodesOnOpen: showEpisodesOnOpen);
}
