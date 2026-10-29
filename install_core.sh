#!/usr/bin/env bash
# Sonora — установщик ядра.
# Создаёт структуру папок и файлы-заготовки. Повторный запуск безопасен.

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "🧱 Sonora: установка ядра в $ROOT"

DIRS=(
  "lib/core/models"
  "lib/core/constants"
  "lib/core/utils"
  "lib/services/yandex"
  "lib/services/soundcloud"
  "lib/services/spotify"
  "lib/services/download"
  "lib/services/player"
  "lib/screens"
  "lib/widgets"
  ".github/workflows"
)
for d in "${DIRS[@]}"; do mkdir -p "$d"; echo "  📁 $d"; done

create_file() {
  local path="$1"; local content="$2"
  if [ -f "$path" ]; then
    echo "  ⏭  $path (уже есть)"
  else
    printf '%s\n' "$content" > "$path"
    echo "  📄 $path"
  fi
}

create_file "lib/main.dart" "import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SonoraApp());
}"

create_file "lib/app.dart" "import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'screens/home_screen.dart';

class SonoraApp extends StatelessWidget {
  const SonoraApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.background),
        colorScheme: const ColorScheme.dark(primary: AppColors.accent),
      ),
      home: const HomeScreen(),
    );
  }
}"

create_file "lib/core/constants/app_colors.dart" "import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF181818);
  static const accent = Color(0xFF1DB954);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB3B3B3);
}"

create_file "lib/core/models/track.dart" "class Track {
  final String id;
  final String title;
  final String artist;
  final String? artworkUrl;
  final String source; // 'yandex' | 'soundcloud' | 'spotify'
  final String? streamUrl;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    this.artworkUrl,
    required this.source,
    this.streamUrl,
  });
}"

create_file "lib/core/utils/youtube_search.dart" "// Поиск YouTube по artist + title (для yt-dlp).
class YoutubeSearch {
  static Future<String?> findVideoUrl(String artist, String title) async {
    return null; // TODO: модуль download
  }
}"

create_file "lib/services/service_locator.dart" "class ServiceLocator {
  static final Map<String, dynamic> _services = {};
  static void register(String key, dynamic service) => _services[key] = service;
  static T? get<T>(String key) => _services[key] as T?;
  static void unregister(String key) => _services.remove(key);
  static void clear() => _services.clear();
}"

create_file "lib/services/player/player_service.dart" "import 'package:just_audio/just_audio.dart';

class PlayerService {
  final AudioPlayer player = AudioPlayer();
  Future<void> playUrl(String url) async {
    await player.setUrl(url);
    player.play();
  }
  void pause() => player.pause();
  void stop() => player.stop();
  Future<void> dispose() async => player.dispose();
}"

create_file "lib/screens/home_screen.dart" "import 'package:flutter/material.dart';
import 'yandex_tab.dart';
import 'soundcloud_tab.dart';
import 'spotify_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [YandexTab(), SoundCloudTab(), SpotifyTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: const Color(0xFF1DB954),
        unselectedItemColor: Colors.grey,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Яндекс'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'SoundCloud'),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Spotify'),
        ],
      ),
    );
  }
}"

create_file "lib/screens/yandex_tab.dart" "import 'package:flutter/material.dart';

class YandexTab extends StatelessWidget {
  const YandexTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Яндекс (модуль не подключён)'));
}"

create_file "lib/screens/soundcloud_tab.dart" "import 'package:flutter/material.dart';

class SoundCloudTab extends StatelessWidget {
  const SoundCloudTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('SoundCloud (модуль не подключён)'));
}"

create_file "lib/screens/spotify_tab.dart" "import 'package:flutter/material.dart';

class SpotifyTab extends StatelessWidget {
  const SpotifyTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Spotify (модуль не подключён)'));
}"

create_file "lib/services/yandex/yandex_service.dart" "// TODO: модуль Яндекс Музыки"
create_file "lib/services/yandex/yandex_auth.dart" "// TODO: WebView-авторизация Яндекса"
create_file "lib/services/soundcloud/soundcloud_service.dart" "// TODO: модуль SoundCloud"
create_file "lib/services/spotify/spotify_service.dart" "// TODO: модуль Spotify"
create_file "lib/services/download/download_service.dart" "// TODO: модуль yt-dlp"
create_file "lib/widgets/track_tile.dart" "// TODO: виджет трека"
create_file "lib/widgets/search_bar.dart" "// TODO: поисковая строка"

echo ""
echo "✅ Ядро Sonora установлено."
echo "   Папок: $(find lib -type d | wc -l | tr -d ' ')"
echo "   Файлов: $(find lib -type f | wc -l | tr -d ' ')"
