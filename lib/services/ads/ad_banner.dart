import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../app_log.dart';

/// One banner for the whole app, loaded once and reused.
///
/// Layout never shifts: the slot's size is known *before* the ad loads
/// (standard anchored adaptive size for the real screen width), so screens
/// reserve that space from their first frame and the ad simply fades in.
/// Only one [AdWidget] may show a [BannerAd] at a time, so screens claim
/// the banner; a second claimant (e.g. during a route transition) shows the
/// reserved, empty slot until the first lets go.
class SharedBanner extends ChangeNotifier {
  SharedBanner(this._unitId);

  final String _unitId;
  BannerAd? _ad;
  AdSize? _size;
  bool _loaded = false;
  bool _loading = false;
  bool _gaveUp = false;
  bool _disabled = false;
  int _failures = 0;
  Object? _owner;
  Timer? _retry;

  static const _retryDelays = [5, 30, 120];

  /// Slot size in real (unscaled) dp, or null until prepared.
  AdSize? get size => (_gaveUp || _disabled) ? null : _size;
  bool get loaded => _loaded && !_disabled;
  BannerAd? get ad => _ad;

  /// Computes the slot size for the device's real width and starts loading.
  Future<void> prepare() async {
    if (_size != null || _disabled) return;
    final view = ui.PlatformDispatcher.instance.views.first;
    final width = (view.physicalSize.width / view.devicePixelRatio).truncate();
    try {
      _size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width) ??
          AdSize.banner;
    } on Object {
      _size = AdSize.banner;
    }
    notifyListeners();
    _load();
  }

  void _load() {
    final size = _size;
    if (size == null || _loading || _loaded || _disabled) return;
    _loading = true;
    final ad = BannerAd(
      adUnitId: _unitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _loading = false;
          _loaded = true;
          _failures = 0;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ad = null;
          _loading = false;
          _failures++;
          AppLog.warn('Banner failed (${error.code}): ${error.message}');
          if (_failures > _retryDelays.length) {
            // Persistent no-fill: release the reserved space once.
            _gaveUp = true;
            notifyListeners();
            return;
          }
          _retry = Timer(Duration(seconds: _retryDelays[_failures - 1]), _load);
        },
      ),
    );
    _ad = ad;
    unawaited(ad.load());
  }

  /// Pro / Remove ads, or consent withdrawn: hide and free the ad.
  void disable() {
    if (_disabled) return;
    _disabled = true;
    _retry?.cancel();
    _ad?.dispose();
    _ad = null;
    _loaded = false;
    notifyListeners();
  }

  bool claim(Object owner) {
    if (_owner != null && !identical(_owner, owner)) return false;
    _owner = owner;
    return true;
  }

  void release(Object owner) {
    if (!identical(_owner, owner)) return;
    _owner = null;
    // Let a waiting slot take over on the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }
}

/// The banner slot for a menu screen. Reserves the ad's height from the
/// first frame; the ad fades in when it fills.
class BannerSlot extends StatefulWidget {
  const BannerSlot({super.key, required this.banner});

  final SharedBanner banner;

  @override
  State<BannerSlot> createState() => _BannerSlotState();
}

class _BannerSlotState extends State<BannerSlot> {
  @override
  void dispose() {
    widget.banner.release(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.banner,
    builder: (context, _) {
      final size = widget.banner.size;
      if (size == null) return const SizedBox.shrink();
      // Inside BpTabletScale the tree is scaled up; ads must render at
      // their real size, so counter-scale the platform view.
      final realDpr = View.of(context).devicePixelRatio;
      final scale = MediaQuery.devicePixelRatioOf(context) / realDpr;
      final w = size.width.toDouble();
      final h = size.height.toDouble();
      final showAd = widget.banner.loaded && widget.banner.claim(this);
      // Anchored banners span the full screen width: the slot reports the
      // width it is given and lets the ad bleed past side padding.
      return SizedBox(
        height: h / scale,
        child: OverflowBox(
          minWidth: w / scale,
          maxWidth: w / scale,
          child: AnimatedOpacity(
          opacity: showAd ? 1 : 0,
          duration: BpMotion.feedback,
          child: showAd
              ? OverflowBox(
                  minWidth: w,
                  maxWidth: w,
                  minHeight: h,
                  maxHeight: h,
                  child: Transform.scale(
                    scale: 1 / scale,
                    child: SizedBox(width: w, height: h, child: AdWidget(ad: widget.banner.ad!)),
                  ),
                )
              : const SizedBox.expand(),
          ),
        ),
      );
    },
  );
}
