import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import '../presentation/bloc/auth/auth_cubit.dart';
import '../services/sync/sync_report.dart';
import 'bp/bp_screen.dart';

/// Plain-words message for a [SyncReport]. [name] is the signed-in player's
/// display name when known (empty → no name).
(String, BpToastKind) syncNotice(AppLocalizations l, SyncReport r, {String name = ''}) {
  final who = name.isEmpty ? l.welcomeBack : l.welcomeBackName(name);
  return switch (r.kind) {
    SyncReportKind.restored when r.combined && r.stats.cloudClears > 0 => (
      l.syncCombined(who, r.totalClears, r.coins),
      BpToastKind.success,
    ),
    SyncReportKind.restored when r.totalClears > 0 || r.coins > 0 => (
      l.syncRestored(who, r.totalClears, r.coins),
      BpToastKind.success,
    ),
    SyncReportKind.restored => (l.syncRestoredEmpty(who), BpToastKind.success),
    SyncReportKind.savedNew => (
      name.isEmpty ? l.syncSavedNewPlain : l.syncSavedNew(name),
      BpToastKind.success,
    ),
    SyncReportKind.fromOtherDevice => (l.syncFromOtherDevice(r.stats.clearsAdded), BpToastKind.info),
    SyncReportKind.restoreFailed => (l.syncRestoreFailed, BpToastKind.error),
  };
}

/// The single toast after a sign-in the player tapped (Settings, boards):
/// what was restored / saved, or why it failed.
void showSignInResult(BuildContext context, AuthCubit cubit, bool ok) {
  final l = AppLocalizations.of(context);
  if (!ok) {
    showBpToast(context, l.signInFailed, kind: BpToastKind.error);
    return;
  }
  final s = cubit.state;
  final who = s.displayName ?? s.username ?? s.email ?? '';
  final report = cubit.takeSignInReport();
  if (report == null) {
    // Firebase signed in but the API was unreachable: say so honestly.
    showBpToast(context, l.signedInOffline, queue: true);
    return;
  }
  final (msg, kind) = syncNotice(l, report, name: who);
  showBpToast(context, msg, kind: kind, queue: true);
}
