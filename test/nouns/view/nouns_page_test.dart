import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/nouns/view/nouns_page.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Nouns', () {
    testWidgets('renders NounsPage', (tester) async {
      await tester.pumpApp(const NounsPage());
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
