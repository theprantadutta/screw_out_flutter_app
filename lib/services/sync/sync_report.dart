/// What a cloud pull did, so the player is told in plain words (restored,
/// combined, synced from another device, or "couldn't load yet").
enum SyncReportKind {
  /// First sign-in to an account that already had cloud progress.
  restored,

  /// First sign-in created the account: this device's progress was saved.
  savedNew,

  /// A routine pull brought in changes made on another device.
  fromOtherDevice,

  /// The first pull failed; it is retried on the next session / resume.
  restoreFailed,
}

/// Counts from one [PullMerger] pass.
final class MergeStats {
  const MergeStats({
    this.cloudClears = 0,
    this.clearsAdded = 0,
    this.clearsImproved = 0,
    this.localClearsUploaded = 0,
    this.dailyAdded = 0,
    this.themesAdded = 0,
    this.coinsBefore = 0,
    this.coinsAfter = 0,
  });

  /// Sheets the account had in the cloud.
  final int cloudClears;

  /// Sheets that arrived on this device.
  final int clearsAdded;

  /// Existing sheets whose best moves / ◆ got better from the cloud.
  final int clearsImproved;

  /// Sheets only this device had (sent up to the account).
  final int localClearsUploaded;
  final int dailyAdded;
  final int themesAdded;
  final int coinsBefore;
  final int coinsAfter;

  /// Something visible changed on this device.
  bool get anythingArrived =>
      clearsAdded > 0 || clearsImproved > 0 || dailyAdded > 0 || themesAdded > 0 || coinsAfter != coinsBefore;
}

final class SyncReport {
  const SyncReport(this.kind, {this.stats = const MergeStats(), this.totalClears = 0, this.coins = 0});

  final SyncReportKind kind;
  final MergeStats stats;

  /// Sheets cleared on this device after the merge.
  final int totalClears;

  /// Coin balance after the merge.
  final int coins;

  /// The device brought progress the account did not have.
  bool get combined => stats.localClearsUploaded > 0;

  @override
  String toString() =>
      'SyncReport($kind, clears=$totalClears, coins=$coins, +${stats.clearsAdded} in, ${stats.localClearsUploaded} up)';
}
