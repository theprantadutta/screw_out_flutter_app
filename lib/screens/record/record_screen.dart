import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../services/badges.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_screen.dart';

/// Workshop record: every milestone with its progress. Earned badges are
/// yellow; the rest show how far along the player is.
class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final statuses = evaluateBadges(context.watch<ProgressCubit>().state);
    final earned = statuses.where((s) => s.earned).length;

    return BpScreenScaffold(
      caption: l.recordCaption,
      title: l.workshopRecord,
      trailing: Text(
        l.recordEarned(earned, statuses.length),
        style: BpType.label.copyWith(color: BpColor.textSecondary, fontFeatures: const [FontFeature.tabularFigures()]),
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          // Phones: two columns. Wider frames (tablets, landscape): three.
          final columns = c.maxWidth >= 560 ? 3 : 2;
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(BpSpace.screen, 20, BpSpace.screen, bpBottom(context, 40)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 148,
            ),
            itemCount: statuses.length,
            itemBuilder: (context, i) => _BadgeTile(status: statuses[i]),
          );
        },
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.status});

  final BadgeStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final b = status.badge;
    final earned = status.earned;
    final accent = earned ? BpColor.action : BpColor.lineFaint;
    return Semantics(
      label: '${b.title(l)}. ${b.detail(l)}. ${earned ? l.badgeEarnedLabel : '${status.progress} / ${b.target}'}',
      excludeSemantics: true,
      child: BpOutlined(
        color: earned ? BpColor.action : BpColor.lineFaint,
        fill: BpColor.card,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(b.icon, size: 26, color: accent),
            const SizedBox(height: 8),
            Text(
              b.title(l),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BpType.body.copyWith(color: earned ? BpColor.line : BpColor.textMuted),
            ),
            const SizedBox(height: 2),
            Text(
              b.detail(l),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: BpType.monoBody.copyWith(fontSize: 10.5, height: 1.35, color: BpColor.textSecondary),
            ),
            const Spacer(),
            if (earned)
              Text(l.badgeEarnedLabel, style: BpType.label.copyWith(color: BpColor.action))
            else
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      alignment: Alignment.centerLeft,
                      color: BpColor.lineFaint.withValues(alpha: .25),
                      child: FractionallySizedBox(
                        widthFactor: status.progress / b.target,
                        child: Container(color: BpColor.line),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${status.progress}/${b.target}',
                    style: BpType.caption.copyWith(color: BpColor.textSecondary, fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
