import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import 'bp_buttons.dart';
import 'bp_grid.dart';

/// Top inset of the header row: the design frame's 38 dp status bar maps to
/// the real safe-area inset.
double bpHeaderTop(BuildContext context) => math.max(MediaQuery.paddingOf(context).top, 24.0) + 14;

/// Bottom inset for anchored primary actions.
double bpBottom(BuildContext context, [double min = 24]) => math.max(min, MediaQuery.paddingOf(context).bottom + 14);

/// 44 dp outline back button: pops, or goes home when there is nothing to pop.
class BpBackButton extends StatelessWidget {
  const BpBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => BpIconButton(
    size: 44,
    iconSize: 22,
    icon: const Icon(Symbols.arrow_back_sharp),
    semanticLabel: AppLocalizations.of(context).back,
    onPressed: onPressed ?? () => bpBack(context),
  );
}

/// Works with and without a GoRouter above (tests use plain MaterialApp).
bool _canPop(BuildContext context) =>
    GoRouter.maybeOf(context)?.canPop() ?? Navigator.of(context).canPop();

void bpBack(BuildContext context) {
  if (GoRouter.maybeOf(context) == null) {
    Navigator.of(context).maybePop();
    return;
  }
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(AppRoutes.home);
  }
}

/// List-screen chrome (04, 05, 06, 14, 15): grid sheet, header row (back +
/// trailing) at the top, optional caption + 38 pt title, then [body].
class BpScreenScaffold extends StatelessWidget {
  const BpScreenScaffold({
    super.key,
    required this.body,
    this.title,
    this.caption,
    this.trailing,
    this.showBack = true,
    this.onBack,
    this.bottom,
  });

  final Widget body;
  final String? title;
  final String? caption;
  final Widget? trailing;
  final bool showBack;
  final VoidCallback? onBack;

  /// Pinned below [body] (e.g. a banner ad).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) => PopScope(
    // A screen opened with go() has nothing beneath it: system back goes
    // home instead of closing the app (same as the on-screen back button).
    canPop: _canPop(context),
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) (onBack ?? () => bpBack(context))();
    },
    child: _body(context),
  );

  Widget _body(BuildContext context) => BpGridBackground(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: bpHeaderTop(context)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BpSpace.screen),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                if (showBack) BpBackButton(onPressed: onBack),
                const Spacer(),
                ?trailing,
              ],
            ),
          ),
        ),
        if (title != null || caption != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(BpSpace.screen, 16, BpSpace.screen, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption != null)
                  Text(caption!, style: BpType.label.copyWith(fontWeight: FontWeight.w400, fontVariations: const [FontVariation('wght', 400)], letterSpacing: 1.32, color: BpColor.textMuted)),
                if (caption != null && title != null) const SizedBox(height: 6),
                if (title != null)
                  Text(title!, style: BpType.screenTitle.copyWith(color: BpColor.line)),
              ],
            ),
          ),
        Expanded(child: body),
        ?bottom,
      ],
    ),
  );
}

/// Mono caption used for section headers ("FEEDBACK", "TITLE"…).
class BpCaption extends StatelessWidget {
  const BpCaption(this.text, {super.key, this.size = 10, this.color = BpColor.textMuted, this.spacing = .14});

  final String text;
  final double size;
  final Color color;
  final double spacing;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: BpType.caption.copyWith(fontSize: size, letterSpacing: size * spacing, color: color),
  );
}

enum BpToastKind { info, success, error }

OverlayEntry? _activeToast;
final List<(OverlayState, String, BpToastKind)> _queuedToasts = [];

/// Toast in Blueprint style: card, white outline, mono text, with a tone
/// marker (success = mint ✓, error = coral ✕). Pinned below the header so it
/// never covers the board, tray or action buttons. One at a time - a new
/// toast replaces the current one, unless [queue] is set: account and sync
/// notices wait their turn so none is lost. Announced to screen readers.
void showBpToast(BuildContext context, String message, {BpToastKind kind = BpToastKind.info, bool queue = false}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  showBpToastOn(overlay, message, kind: kind, queue: queue);
}

/// [showBpToast] for callers outside any screen (app-wide notices), which
/// hold the root navigator's overlay rather than a context below it.
void showBpToastOn(OverlayState overlay, String message, {BpToastKind kind = BpToastKind.info, bool queue = false}) {
  if (queue && _activeToast != null) {
    _queuedToasts.add((overlay, message, kind));
    return;
  }
  _insertToast(overlay, message, kind);
}

void _insertToast(OverlayState overlay, String message, BpToastKind kind) {
  _activeToast?.remove();
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _Toast(
      message: message,
      kind: kind,
      onDone: () {
        if (entry.mounted) entry.remove();
        if (!identical(_activeToast, entry)) return;
        _activeToast = null;
        while (_queuedToasts.isNotEmpty) {
          final (o, m, k) = _queuedToasts.removeAt(0);
          if (o.mounted) {
            _insertToast(o, m, k);
            break;
          }
        }
      },
    ),
  );
  _activeToast = entry;
  overlay.insert(entry);
}

class _Toast extends StatefulWidget {
  const _Toast({required this.message, required this.kind, required this.onDone});

  final String message;
  final BpToastKind kind;
  final VoidCallback onDone;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: BpMotion.feedback)..forward();
  Timer? _t;

  @override
  void initState() {
    super.initState();
    // Long notices stay up long enough to read (~50 ms a character).
    final base = widget.kind == BpToastKind.error ? 3200 : 2400;
    final ms = math.max(base, math.min(6000, widget.message.length * 50));
    _t = Timer(Duration(milliseconds: ms), () async {
      if (!mounted) return;
      await _c.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (widget.kind) {
      BpToastKind.success => (BpColor.success, Symbols.check_sharp),
      BpToastKind.error => (BpColor.blocked, Symbols.close_sharp),
      BpToastKind.info => (BpColor.line, Symbols.info_sharp),
    };
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Positioned(
      left: BpSpace.screen,
      right: BpSpace.screen,
      top: bpHeaderTop(context) + 56,
      child: IgnorePointer(
        child: Semantics(
          liveRegion: true,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) {
              final t = BpMotion.standardOut.transform(_c.value);
              return Opacity(
                opacity: _c.value,
                child: Transform.translate(offset: Offset(0, reduced ? 0 : -8 * (1 - t)), child: child),
              );
            },
            child: Material(
              type: MaterialType.transparency,
              child: CustomPaint(
                foregroundPainter: BpBorderPainter(color: color == BpColor.line ? BpColor.lineDefault : color),
                child: Container(
                  color: BpColor.card,
                  padding: const EdgeInsets.fromLTRB(12, 11, 14, 11),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        color: color,
                        alignment: Alignment.center,
                        child: Icon(icon, size: 16, color: BpColor.ink, weight: 600),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(widget.message, style: BpType.monoBody.copyWith(color: BpColor.line, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Row of tick boxes (campaign progress / chapter complete).
class BpTickStrip extends StatelessWidget {
  const BpTickStrip({super.key, required this.states, this.height = 10, this.gap = 3});

  /// One entry per box.
  final List<BpTick> states;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < states.length; i++) ...[
        if (i > 0) SizedBox(width: gap),
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: switch (states[i]) {
                BpTick.done => BpColor.line,
                BpTick.current => BpColor.action,
                BpTick.empty => BpColor.transparent,
              },
              border: Border.all(
                color: states[i] == BpTick.current ? BpColor.action : BpColor.lineMuted,
                width: BpSize.hairline,
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

enum BpTick { done, current, empty }
