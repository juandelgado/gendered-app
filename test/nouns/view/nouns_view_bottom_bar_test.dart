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

  group('NounsView NounsBottomBar', () {
    late NounsCubit mockCubit;

    setUpAll(() {
      mockCubit = MockNounsCubit();
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
