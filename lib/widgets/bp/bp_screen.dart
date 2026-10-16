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

/// One-line toast in Blueprint style (card, white outline, mono text).
void showBpToast(BuildContext context, String message) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  late OverlayEntry entry;
  entry = OverlayEntry(builder: (context) => _Toast(message: message, onDone: () => entry.remove()));
  overlay.insert(entry);
}

class _Toast extends StatefulWidget {
  const _Toast({required this.message, required this.onDone});

  final String message;
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
    _t = Timer(const Duration(milliseconds: 2200), () async {
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
  Widget build(BuildContext context) => Positioned(
    left: BpSpace.screen,
    right: BpSpace.screen,
    bottom: bpBottom(context, 40) + 80,
    child: IgnorePointer(
      child: FadeTransition(
        opacity: _c,
        child: Material(
          type: MaterialType.transparency,
          child: BpOutlined(
            color: BpColor.line,
            fill: BpColor.card,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(widget.message, textAlign: TextAlign.center, style: BpType.monoBody.copyWith(color: BpColor.line)),
          ),
        ),
      ),
    ),
  );
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
