import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/app/app.dart';
import 'package:gendered/nouns/view/nouns_page.dart';

void main() {
  group('App', () {
    testWidgets('renders Nouns page', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(NounsPage), findsOneWidget);
    });
  });
}
