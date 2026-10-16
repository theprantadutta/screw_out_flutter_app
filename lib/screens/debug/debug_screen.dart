import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../router/routes.dart';
import '../../services/progress_service.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_screen.dart';

/// Debug-only shortcuts for QA (never reachable in release builds): jump to
/// any sheet, fake progress, open screens that need long play to reach.
class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    final progress = context.read<ProgressService>();
    Widget button(String label, Future<void> Function() onTap) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: BpOutlineButton(
        height: 44,
        onPressed: () async {
          await onTap();
        },
        child: Text(label, style: BpType.monoSmallButton),
      ),
    );
    return BpScreenScaffold(
      title: 'Debug',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(BpSpace.screen, 14, BpSpace.screen, 40),
        children: [
          button('CLEAR SHEETS 1–3', () => progress.debugMarkCleared(3)),
          button('CLEAR SHEETS 1–11 (→ DWG 012)', () => progress.debugMarkCleared(11)),
          button('CLEAR SHEETS 1–19 (→ CH1 FINALE)', () => progress.debugMarkCleared(19)),
          button('CLEAR SHEETS 1–23 (→ DWG 024)', () => progress.debugMarkCleared(23)),
          button('+1000 COINS', () => progress.earn(1000, 'debug')),
          button('OPEN DWG 024', () async => context.go(AppRoutes.playPath(24))),
          button('OPEN CHAPTER 01 COMPLETE', () async => context.go(AppRoutes.chapterCompletePath(1))),
          button('OPEN CHAPTER 02 COMPLETE', () async => context.go(AppRoutes.chapterCompletePath(2))),
          button('RESET TUTORIAL', () async {
            final s = context.read<SettingsCubit>();
            await s.setTutorialDone(false);
          }),
          button('RESET ALL PROGRESS', () => progress.debugReset()),
        ],
      ),
    );
  }
}
