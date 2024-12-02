import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

const feminineNoun =
    Noun(name: 'Wadus', gender: Gender.feminine, definitions: []);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Noun(name: 'wadus', gender: Gender.feminine, definitions: []),
    );
    registerFallbackValue(Gender.neuter);
  });

  group('NounsViewIncorrect', () {
    late NounsCubit mockCubit;

    setUpAll(() {
      mockCubit = MockNounsCubit();
    });

    testWidgets('renders NounsViewIncorrect for NounsIncorrect',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(NounsIncorrect(noun: feminineNoun, attempt: 1));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );
      expect(find.byType(NounsViewIncorrect), findsOneWidget);
      await tester.a11yCheck();
    });
  });
}
