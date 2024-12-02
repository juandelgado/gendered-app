import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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

    for (final attempt in [1, 2, 3, 4, 5]) {
      testWidgets('renders incorrect attempts for attempt: $attempt',
          (tester) async {
        when(() => mockCubit.state)
            .thenReturn(NounsIncorrect(noun: feminineNoun, attempt: attempt));

        await tester.pumpApp(
          BlocProvider.value(
            value: mockCubit,
            child: const NounsView(),
          ),
        );

        final incorrectAttemptsFinder =
            find.byKey(const Key('incorrectAttempts'));

        final textWidget =
            incorrectAttemptsFinder.evaluate().single.widget as Text;

        expect(textWidget.data, '!' * min(3, attempt - 1));

        await tester.a11yCheck();
      });
    }
  });
}
