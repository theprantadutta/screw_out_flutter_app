import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/widgets/bp/bp_grid.dart';
import 'package:screw_out/widgets/bp/bp_screen.dart';

import '../helpers/harness.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final kind in BpToastKind.values) {
    testWidgets('toast ${kind.name}', (tester) async {
      useDesignFrame(tester);
      await tester.pumpWidget(appShell(child: const BpGridBackground()));
      final context = tester.element(find.byType(BpGridBackground));
      final message = switch (kind) {
        BpToastKind.success => 'Signed in as Pranta Dutta · progress is backed up',
        BpToastKind.error => 'Not enough coins yet.',
        BpToastKind.info => 'Signed out. Progress on this device stays.',
      };
      showBpToast(context, message, kind: kind);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(message), findsOneWidget);

      await expectLater(find.byType(Overlay).first, matchesGoldenFile('goldens/toast-${kind.name}.png'));
      await tester.pump(const Duration(seconds: 4));
    });
  }
}
