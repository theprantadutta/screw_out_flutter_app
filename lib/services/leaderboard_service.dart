import '../core/network/api_service.dart';

enum Board {
  /// Most sheets cleared (then most mastered).
  sheets('levels'),

  /// Today's daily sheet: fewest moves, then fastest.
  daily('daily'),

  /// Current daily streak.
  streak('streak');

  const Board(this.apiName);
  final String apiName;

  static Board fromName(String? name) =>
      Board.values.firstWhere((b) => b.name == name || b.apiName == name, orElse: () => Board.sheets);
}

final class BoardEntry {
  const BoardEntry({
    required this.rank,
    required this.username,
    required this.isMe,
    this.levelsCleared = 0,
    this.mastered = 0,
    this.moves = 0,
    this.timeMs = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  factory BoardEntry.fromJson(Map<String, dynamic> j) => BoardEntry(
    rank: (j['rank'] as num?)?.toInt() ?? 0,
    username: j['username'] as String? ?? '-',
    isMe: j['is_me'] == true,
    levelsCleared: (j['levels_cleared'] as num?)?.toInt() ?? 0,
    mastered: (j['mastered_count'] as num?)?.toInt() ?? 0,
    moves: (j['moves'] as num?)?.toInt() ?? 0,
    timeMs: (j['time_ms'] as num?)?.toInt() ?? 0,
    currentStreak: (j['current_streak'] as num?)?.toInt() ?? 0,
    bestStreak: (j['best_streak'] as num?)?.toInt() ?? 0,
  );

  final int rank;
  final String username;
  final bool isMe;
  final int levelsCleared;
  final int mastered;
  final int moves;
  final int timeMs;
  final int currentStreak;
  final int bestStreak;
}

final class BoardPage {
  const BoardPage({required this.board, required this.entries, required this.totalPlayers, this.me});

  final Board board;
  final List<BoardEntry> entries;
  final int totalPlayers;

  /// The signed-in player's standing; null for guests / not on the board.
  final BoardEntry? me;
}

/// Leaderboards (signed-in players; guests can browse).
abstract interface class LeaderboardPort {
  /// Null when the board can't be reached (offline / server down).
  Future<BoardPage?> fetch(Board board, {required DateTime today, bool signedIn = false});
}

class LeaderboardService implements LeaderboardPort {
  LeaderboardService(this._api);

  final ApiService _api;

  static String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<BoardPage?> fetch(Board board, {required DateTime today, bool signedIn = false}) async {
    // Daily boards use the player's *local* date (contract §5).
    final date = board == Board.daily ? _date(today) : null;
    final page = await _api.leaderboard(board.apiName, date: date, limit: 50);
    final data = page.value;
    if (!page.isSuccess || data == null) return null;
    final entries = [
      for (final e in (data['entries'] as List? ?? const []))
        if (e is Map) BoardEntry.fromJson(e.cast<String, dynamic>()),
    ];
    BoardEntry? me;
    if (signedIn) {
      final mine = await _api.myRank(board.apiName, date: date);
      final entry = mine.value?['entry'];
      if (mine.isSuccess && entry is Map) me = BoardEntry.fromJson(entry.cast<String, dynamic>());
    }
    me ??= entries.where((e) => e.isMe).firstOrNull;
    return BoardPage(
      board: board,
      entries: entries,
      totalPlayers: (data['total_players'] as num?)?.toInt() ?? entries.length,
      me: me,
    );
  }
}
