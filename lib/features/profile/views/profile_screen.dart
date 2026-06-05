import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/app_data_controller.dart';
import '../controllers/profile_controller.dart';

/// Profile = user header, premium banner and a settings list (drama-app style).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final data = Get.find<AppDataController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Obx(() {
            data.liked.length;
            data.history.length;
            return _header(controller.favoriteCount, controller.watchedCount);
          }),
          const SizedBox(height: 16),
          _premiumBanner(),
          const SizedBox(height: 8),
          _section('Account', const [
            _Tile(Icons.person_outline, 'Edit profile'),
            _Tile(Icons.workspace_premium_outlined, 'My subscription'),
            _Tile(Icons.account_balance_wallet_outlined, 'Coins & rewards'),
          ]),
          _section('Preferences', const [
            _Tile(Icons.language, 'Language'),
            _Tile(Icons.notifications_none, 'Notifications'),
            _Tile(Icons.download_outlined, 'Downloads'),
          ]),
          _section('Support', const [
            _Tile(Icons.help_outline, 'Help center'),
            _Tile(Icons.info_outline, 'About'),
            _Tile(Icons.logout, 'Log out'),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(int favorites, int watched) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 44,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 52, color: Colors.white),
        ),
        const SizedBox(height: 12),
        const Text(
          '@your_handle',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text('ID: 1024 · Free member',
            style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _stat('128', 'Following'),
            _stat('12.4K', 'Followers'),
            _stat('$favorites', 'Favorites'),
            _stat('$watched', 'Watched'),
          ],
        ),
      ],
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _premiumBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB75E), Color(0xFFED8F03)],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Go Premium',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('Unlimited reels · No ads',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<_Tile> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ),
        ...tiles,
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tile(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: () {},
    );
  }
}
