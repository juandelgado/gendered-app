import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

void main() {
  group('NounsPage', () {
    late NounsCubit mockCubit;

    setUpAll(() {
      mockCubit = MockNounsCubit();
    });

    testWidgets('renders', (tester) async {
      when(() => mockCubit.load()).thenAnswer(
        (_) async => {},
      );
      when(() => mockCubit.state).thenReturn(NounsInitial());
      await tester.pumpApp(
        NounsPage(
          cubit: mockCubit,
        ),
      );
      expect(find.byType(NounsView), findsOneWidget);
      await tester.a11yCheck();
    });
  });
}
