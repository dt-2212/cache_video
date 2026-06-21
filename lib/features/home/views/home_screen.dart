import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/video.dart';
import '../../../core/widgets/feed_viewer_screen.dart';
import '../../../core/widgets/poster_tile.dart';
import '../controllers/home_controller.dart';

/// Home = live-TV discovery page (iptv-org): featured banner + category rails.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (controller.error.isNotEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: controller.load,
          );
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              floating: true,
              title: const Text('Live TV',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.load),
              ],
            ),
            SliverToBoxAdapter(
                child: _FeaturedCarousel(videos: controller.featured)),
            for (final rail in controller.rails)
              SliverToBoxAdapter(
                child: _Rail(title: rail.title, videos: rail.videos),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      }),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.live_tv, color: Colors.white38, size: 56),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  final List<Video> videos;
  const _FeaturedCarousel({required this.videos});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _controller = PageController(viewportFraction: 0.9);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videos.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.videos.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              final video = widget.videos[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: GestureDetector(
                  onTap: () => openFeed(widget.videos, i),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [video.thumbColor, Colors.black],
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (video.logoUrl != null)
                            Center(
                              child: Image.network(
                                video.logoUrl!,
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Icon(
                                    Icons.live_tv,
                                    color: Colors.white70,
                                    size: 54),
                              ),
                            )
                          else
                            const Center(
                              child: Icon(Icons.live_tv,
                                  color: Colors.white70, size: 54),
                            ),
                          const Positioned(
                            top: 12, right: 12, child: _LiveBadge()),
                          Positioned(
                            left: 16,
                            bottom: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  child: Text(
                                    video.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  video.category,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.videos.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _page ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _page ? Colors.white : Colors.white30,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('LIVE',
          style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _Rail extends StatelessWidget {
  final String title;
  final List<Video> videos;
  const _Rail({required this.title, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 222,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: videos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => PosterTile(
              video: videos[i],
              onTap: () => openFeed(videos, i),
            ),
          ),
        ),
      ],
    );
  }
}
