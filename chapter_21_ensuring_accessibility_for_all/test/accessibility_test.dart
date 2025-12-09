import 'package:chapter_21_ensuring_accessibility_for_all/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/semantics.dart';

void main() {
  testWidgets('HomePage meets accessibility guidelines', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(const AccessibilityPlaygroundPage());

    await expectLater(
      tester,
      meetsGuideline(androidTapTargetGuideline),
    );

    await expectLater(
      tester,
      meetsGuideline(iOSTapTargetGuideline),
    );

    await expectLater(
      tester,
      meetsGuideline(labeledTapTargetGuideline),
    );

    handle.dispose();
  });

  testWidgets('Text contrast meets guidelines', (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(const AccessibilityPlaygroundPage());

    await expectLater(
      tester,
      meetsGuideline(textContrastGuideline),
    );

    handle.dispose();
  });

  testWidgets('Check semantics on a button', (tester) async {
    await tester.pumpWidget(const AccessibilityPlaygroundPage());
    final SemanticsHandle handle = tester.ensureSemantics();

    // You can add a Key to your "Submit" button and test it here.
    final Finder submitButton = find.byKey(const Key('playButton'));

    expect(
      tester.getSemantics(submitButton),
      matchesSemantics(
        hasTapAction: true,
        isButton: true,
        label: 'Submit',
      ),
    );
    handle.dispose();
  });
}
