import 'package:cenoyam/presentation/widget/track_entry_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/test_data.dart';

void main() {
  final data = TestData();

  testWidgets('Renders track', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TrackEntryWidget(
          data.trackEntity,
          () {},
        ),
      ),
    );
    expect(find.textContaining(data.trackEntity.title), findsOneWidget);
    expect(find.textContaining(data.trackEntity.artistString), findsOneWidget);
  });

  testWidgets('Can play available track', (tester) async {
    var activated = false;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TrackEntryWidget(
          data.trackEntity,
          () {
            activated = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('|>'));

    expect(activated, true);
  });

  testWidgets('Can not play unavailable track', (tester) async {
    var activated = false;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: TrackEntryWidget(
          data.unavailableTrackEntity,
          () {
            activated = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('|>'));

    expect(activated, false);
  });
}
