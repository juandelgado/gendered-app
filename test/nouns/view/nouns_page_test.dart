import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/extensions/string_extensions.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../cubit/nouns_cubit_test.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Noun(name: 'wadus', gender: Gender.feminine, definitions: []),
    );
    registerFallbackValue(Gender.neuter);
  });

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

  group('NounsView', () {
    late NounsCubit mockCubit;

    setUpAll(() {
      mockCubit = MockNounsCubit();
    });

    testWidgets('renders NounsViewLoading for NounsInitial', (tester) async {
      when(() => mockCubit.state).thenReturn(NounsInitial());

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      expect(find.byType(NounsViewLoading), findsOneWidget);
      await tester.a11yCheck();
    });

    testWidgets('renders NounsViewLoading for NounsLoading', (tester) async {
      when(() => mockCubit.state).thenReturn(NounsLoading());

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      expect(find.byType(NounsViewLoading), findsOneWidget);
      await tester.a11yCheck();
    });

    testWidgets('renders NounsViewLoadingError for NounsLoadingError',
        (tester) async {
      when(() => mockCubit.state).thenReturn(NounsLoadingError());
      when(() => mockCubit.load()).thenAnswer((_) async => {});

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      expect(find.byType(NounsViewLoadingError), findsOneWidget);
      await tester.tap(find.byKey(NounsViewLoadingError.tryAgainKey));

      verify(() => mockCubit.load()).called(1);
      await tester.a11yCheck();
    });

    testWidgets('renders NounsViewIncorrect for NounsIncorrect',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(NounsIncorrect(noun: feminineNoun));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );
      expect(find.byType(NounsViewIncorrect), findsOneWidget);
      await tester.a11yCheck();
    });

    testWidgets('renders NounsViewCorrect for NounsCorrect', (tester) async {
      when(() => mockCubit.state).thenReturn(NounsCorrect(noun: feminineNoun));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      expect(find.byType(NounsViewCorrect), findsOneWidget);
      await tester.a11yCheck();
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

    testWidgets('bottom bar buttons are disabled during loading',
        (tester) async {
      when(() => mockCubit.state).thenReturn(NounsLoading());

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      final genders = LanguageCubit().state.genders;
      for (final gender in genders) {
        final genderWidget =
            find.byKey(Key('selectGender${gender.name.capitalize()}'));
        await tester.tap(genderWidget);
      }
      await tester.tap(find.byKey(NounsBottomBar.nextKey));
      await tester.tap(find.byKey(NounsBottomBar.previousKey));

      verifyNever(
        () => mockCubit.validate(
          noun: any(named: 'noun'),
          answer: any(named: 'answer'),
        ),
      );
      verifyNever(() => mockCubit.previous());
      verifyNever(() => mockCubit.load());

      await tester.a11yCheck();
    });

    testWidgets('bottom bar buttons are disabled during NounsCorrect',
        (tester) async {
      when(() => mockCubit.state).thenReturn(NounsCorrect(noun: feminineNoun));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      final genders = LanguageCubit().state.genders;
      for (final gender in genders) {
        final genderWidget =
            find.byKey(Key('selectGender${gender.name.capitalize()}'));
        await tester.tap(genderWidget);
      }
      await tester.tap(find.byKey(NounsBottomBar.nextKey));
      await tester.tap(find.byKey(NounsBottomBar.previousKey));

      verifyNever(
        () => mockCubit.validate(
          noun: any(named: 'noun'),
          answer: any(named: 'answer'),
        ),
      );
      verifyNever(() => mockCubit.previous());
      verifyNever(() => mockCubit.load());

      await tester.a11yCheck();
    });
  });
}
