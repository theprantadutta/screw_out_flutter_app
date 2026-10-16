/// Route paths (go_router). Every GoRoute also carries a `name` for
/// analytics screen views.
abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const campaign = '/campaign';
  static const chapter = '/chapter/:chapter';
  static const play = '/play/:level';
  static const daily = '/daily';
  static const dailyPlay = '/daily/play';
  static const chapterComplete = '/chapter-complete/:chapter';
  static const themes = '/themes';
  static const settings = '/settings';
  static const licenses = '/licenses';
  static const debug = '/debug';
  static const leaderboard = '/leaderboard';

  static String chapterPath(int chapter) => '/chapter/$chapter';
  static String playPath(int level) => '/play/$level';
  static String chapterCompletePath(int chapter) => '/chapter-complete/$chapter';
}
