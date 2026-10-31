import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldens are recorded on the Mac (the reference machine) and compared
/// strictly there. Other machines render fonts a little differently (up to
/// ~4% of pixels on these screens), so they compare with a tolerance: the
/// suite passes on Windows too, while a real layout change still fails.
/// Re-record goldens on the Mac (see docs/MACOS_NOTES.md).
const _offReferenceTolerance = 0.05;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final comparator = goldenFileComparator;
  if (!Platform.isMacOS && comparator is LocalFileComparator) {
    goldenFileComparator = _TolerantComparator(
      Uri.parse('${comparator.basedir}flutter_test_config.dart'),
      _offReferenceTolerance,
    );
  }
  await testMain();
}

class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(super.testFile, this.tolerance);

  /// Largest share of differing pixels still accepted (0.05 = 5%).
  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));
    if (result.passed || result.diffPercent <= tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
