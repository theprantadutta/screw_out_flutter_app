import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../services/leaderboard_service.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_screen.dart';
import '../../widgets/sync_notices.dart';

/// Leaderboards: SHEETS · DAILY · STREAK. Kept deliberately simple - one
/// list, your row highlighted, your standing pinned at the bottom.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key, this.initial = Board.sheets, this.today});

  final Board initial;

  /// Overridable clock for tests.
  final DateTime? today;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Board _board = widget.initial;
  final Map<Board, BoardPage?> _pages = {};
  final Set<Board> _loading = {};
  final Set<Board> _failed = {};

  DateTime get _today => widget.today ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _load(_board);
  }

  Future<void> _load(Board board, {bool force = false}) async {
    if (!force && (_pages.containsKey(board) || _loading.contains(board))) return;
    setState(() {
      _loading.add(board);
      _failed.remove(board);
    });
    final signedIn = !context.read<AuthCubit>().state.isGuest;
    final page = await context.read<LeaderboardPort>().fetch(board, today: _today, signedIn: signedIn);
    if (!mounted) return;
    setState(() {
      _loading.remove(board);
      if (page == null) {
        _failed.add(board);
      } else {
        _pages[board] = page;
      }
    });
  }

  void _select(Board b) {
    setState(() => _board = b);
    _load(b);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final page = _pages[_board];
    final auth = context.watch<AuthCubit>().state;
    return BpScreenScaffold(
      title: l.leaderboardTitle,
      caption: l.leaderboardCaption,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BpSpace.screen),
            child: _Tabs(
              selected: _board,
              labels: {Board.sheets: l.boardSheets, Board.daily: l.boardDaily, Board.streak: l.boardStreak},
              onSelect: _select,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BpSpace.screen),
            child: Text(_subtitle(l), style: BpType.caption.copyWith(color: BpColor.textMuted)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              color: BpColor.ink,
              backgroundColor: BpColor.action,
              onRefresh: () => _load(_board, force: true),
              child: _body(l, page),
            ),
          ),
          _MeBar(page: page, guest: auth.isGuest, loading: _loading.contains(_board)),
        ],
      ),
    );
  }

  String _subtitle(AppLocalizations l) => switch (_board) {
    Board.sheets => l.boardSheetsHint,
    Board.daily => l.boardDailyHint,
    Board.streak => l.boardStreakHint,
  };

  Widget _body(AppLocalizations l, BoardPage? page) {
    final pad = const EdgeInsets.symmetric(horizontal: BpSpace.screen);
    if (page == null && _failed.contains(_board)) {
      return ListView(
        padding: pad,
        children: [
          const SizedBox(height: 40),
          _Message(icon: Symbols.cloud_off_sharp, text: l.boardOffline),
          const SizedBox(height: 16),
          BpOutlineButton(onPressed: () => _load(_board, force: true), child: Text(l.tryAgainCaps, style: BpType.monoSmallButton)),
        ],
      );
    }
    if (page == null) {
      // Static skeleton rows (no shimmer - nothing loops while you wait).
      return ListView(
        padding: pad,
        physics: const NeverScrollableScrollPhysics(),
        children: [for (var i = 0; i < 8; i++) const _SkeletonRow()],
      );
    }
    if (page.entries.isEmpty) {
      return ListView(
        padding: pad,
        children: [const SizedBox(height: 40), _Message(icon: Symbols.flag_sharp, text: l.boardEmpty)],
      );
    }
    return ListView.builder(
      padding: pad.copyWith(bottom: 12),
      itemCount: page.entries.length,
      itemBuilder: (context, i) => _Row(entry: page.entries[i], board: _board),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.labels, required this.onSelect});

  final Board selected;
  final Map<Board, String> labels;
  final ValueChanged<Board> onSelect;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final b in Board.values) ...[
        if (b != Board.values.first) const SizedBox(width: 8),
        Expanded(
          child: Semantics(
            button: true,
            selected: b == selected,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (b != selected) {
                  bpUiTick?.call();
                  onSelect(b);
                }
              },
              child: AnimatedContainer(
                duration: BpMotion.feedback,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: b == selected ? BpColor.line : BpColor.transparent,
                  border: Border.all(color: b == selected ? BpColor.line : BpColor.lineMuted, width: BpSize.stroke),
                ),
                child: Text(
                  labels[b]!,
                  style: BpType.label.copyWith(color: b == selected ? BpColor.sheet : BpColor.textSecondary),
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

String _pad(int n) => n.toString().padLeft(2, '0');

String _time(int ms) {
  final s = ms ~/ 1000;
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

class _Row extends StatelessWidget {
  const _Row({required this.entry, required this.board});

  final BoardEntry entry;
  final Board board;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (value, detail) = switch (board) {
      Board.sheets => ('${entry.levelsCleared}', l.boardMastered(entry.mastered)),
      Board.daily => ('${entry.moves}', l.boardMovesDetail(entry.moves, _time(entry.timeMs))),
      Board.streak => ('${entry.currentStreak}', l.boardDaysDetail(entry.currentStreak, entry.bestStreak)),
    };
    final me = entry.isMe;
    return Container(
      height: 56,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: me ? BpColor.card : BpColor.transparent,
        border: Border.all(color: me ? BpColor.action : BpColor.divider, width: me ? BpSize.emphasis : BpSize.hairline),
      ),
      child: Row(
        children: [
          _RankBadge(rank: entry.rank),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BpType.body.copyWith(color: BpColor.line),
                  ),
                ),
                if (me) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: BpColor.action,
                    child: Text(l.boardYou, style: BpType.slotTag.copyWith(fontSize: 9, color: BpColor.ink)),
                  ),
                ],
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: BpType.statValue.copyWith(fontSize: 17, color: BpColor.line)),
              Text(detail, style: BpType.caption.copyWith(fontSize: 9, color: BpColor.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

/// #1 in drafting yellow, #2–3 outlined, the rest plain mono numbers.
class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final text = BpType.monoButtonBold.copyWith(
      fontSize: 13,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    if (rank == 1) {
      return Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        color: BpColor.action,
        child: Text(_pad(rank), style: text.copyWith(color: BpColor.ink)),
      );
    }
    if (rank <= 3) {
      return Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: BpColor.line, width: BpSize.stroke)),
        child: Text(_pad(rank), style: text.copyWith(color: BpColor.line)),
      );
    }
    return SizedBox(
      width: 32,
      child: Text(_pad(rank), textAlign: TextAlign.center, style: text.copyWith(color: BpColor.textMuted)),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    margin: const EdgeInsets.only(bottom: 6),
    child: const BpOutlined(color: BpColor.divider, width: BpSize.hairline, dashed: true, child: SizedBox.expand()),
  );
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, size: 28, color: BpColor.textMuted),
      const SizedBox(height: 12),
      Text(text, textAlign: TextAlign.center, style: BpType.monoBody.copyWith(color: BpColor.textSecondary)),
    ],
  );
}

/// Your standing, pinned under the list. Guests get one clear way in.
class _MeBar extends StatelessWidget {
  const _MeBar({required this.page, required this.guest, required this.loading});

  final BoardPage? page;
  final bool guest;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bottom = bpBottom(context, 16);
    Widget shell(Widget child) => Container(
      padding: EdgeInsets.fromLTRB(BpSpace.screen, 12, BpSpace.screen, bottom),
      decoration: const BoxDecoration(
        color: BpColor.card,
        border: Border(top: BorderSide(color: BpColor.lineDefault, width: BpSize.stroke)),
      ),
      child: child,
    );
    if (guest) {
      final auth = context.read<AuthCubit>();
      return shell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.boardGuest, style: BpType.monoBody.copyWith(color: BpColor.textSecondary)),
            const SizedBox(height: 10),
            BpPrimaryButton(
              height: 48,
              onPressed: () async {
                final ok = await auth.signInWithGoogle();
                if (context.mounted) showSignInResult(context, auth, ok);
              },
              child: Text(l.signInGoogle),
            ),
          ],
        ),
      );
    }
    final me = page?.me;
    if (page == null || loading) return shell(const SizedBox(height: 40));
    return shell(
      Row(
        children: [
          Text(l.boardYourRank, style: BpType.label.copyWith(color: BpColor.textMuted)),
          const Spacer(),
          if (me == null)
            Text(l.boardNotRanked, style: BpType.monoBody.copyWith(color: BpColor.textSecondary))
          else ...[
            Text('#${me.rank}', style: BpType.statValue.copyWith(fontSize: 22, color: BpColor.action)),
            const SizedBox(width: 8),
            Text(l.boardOfPlayers(page!.totalPlayers), style: BpType.caption.copyWith(color: BpColor.textMuted)),
          ],
        ],
      ),
    );
  }
}
