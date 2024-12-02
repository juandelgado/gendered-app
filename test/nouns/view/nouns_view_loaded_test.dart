import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/extensions/string_extensions.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/language.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

class MockLanguageCubit extends MockCubit<Language> implements LanguageCubit {}

const feminineNoun =
    Noun(name: 'Wadus', gender: Gender.feminine, definitions: []);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Noun(name: 'wadus', gender: Gender.feminine, definitions: []),
    );
    registerFallbackValue(Gender.neuter);
  });

  group('NounsViewLoaded', () {
    late NounsCubit mockCubit;
    late LanguageCubit mockLanguageCubit;

    setUpAll(() {
      mockCubit = MockNounsCubit();
      mockLanguageCubit = MockLanguageCubit();
    });

    testWidgets('renders NounsViewLoaded for NounsLoaded', (tester) async {
      when(() => mockCubit.state).thenReturn(NounsLoaded(noun: feminineNoun));
      when(
        () => mockCubit.validate(
          noun: any(named: 'noun', that: isA<Noun>()),
          answer: any(named: 'answer', that: isA<Gender>()),
        ),
      ).thenAnswer((_) async => {});

      when(() => mockCubit.load()).thenAnswer((_) async => {});
      when(() => mockCubit.previous()).thenAnswer((_) async => {});

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      expect(find.byType(NounsViewLoaded), findsOneWidget);

      expect(find.byKey(const Key('localisedNoun')), findsOneWidget);
      expect(
        find.byKey(const Key('localisedDefintition')),
        findsNWidgets(feminineNoun.definitions.length),
      );

      // we should try to set or pick up from context
      // the language instead of assuming it is the default
      final genders = LanguageCubit().state.genders;
      for (final gender in genders) {
        final genderWidget =
            find.byKey(Key('selectGender${gender.name.capitalize()}'));

        expect(
          genderWidget,
          findsOneWidget,
        );

        await tester.tap(genderWidget);
        verify(() => mockCubit.validate(noun: feminineNoun, answer: gender))
            .called(1);

        await tester.tap(find.byKey(NounsBottomBar.nextKey));
        verify(() => mockCubit.load()).called(1);

        await tester.tap(find.byKey(NounsBottomBar.previousKey));
        verify(() => mockCubit.previous()).called(1);

        await tester.a11yCheck();
      }
    });

    testWidgets('calls text to speech when the noun is tapped', (tester) async {
      when(() => mockCubit.state).thenReturn(NounsLoaded(noun: feminineNoun));
      when(() => mockLanguageCubit.state).thenReturn(German());
      when(() => mockLanguageCubit.textToSpeech(text: any(named: 'text')))
          .thenAnswer((_) async => {});

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
        languageCubit: mockLanguageCubit,
      );

      await tester.tap(find.byKey(const Key('localisedNoun')));
      verify(
        () => mockLanguageCubit.textToSpeech(
          text: any(named: 'text', that: equals(feminineNoun.name)),
        ),
      ).called(1);
    });
  });
}
