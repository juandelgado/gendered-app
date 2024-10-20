import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/repository/nouns_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNounsRepository extends Mock implements NounsRepository {}

const feminineNoun = Noun(name: 'Wadus', gender: Gender.feminine);
const neuterNoun = Noun(name: 'WadusWadus', gender: Gender.neuter);

void main() {
  group('Nouns Cubit', () {
    late NounsCubit cubit;
    late MockNounsRepository mockRepository;

    setUp(() {
      mockRepository = MockNounsRepository();
      cubit = NounsCubit(repository: mockRepository);
    });

    test('initial state is NounsInitial', () {
      expect(cubit.state, isA<NounsInitial>());
    });

    blocTest<NounsCubit, NounsState>(
      'emits NounsLoading and NounsLoaded during load',
      setUp: () {
        when(() => mockRepository.load()).thenAnswer(
          (_) async => feminineNoun,
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => [isA<NounsLoading>(), isA<NounsLoaded>()],
      verify: (cubit) {
        final noun = (cubit.state as NounsLoaded).noun;
        expect(noun.name, feminineNoun.name);
        expect(noun.gender, feminineNoun.gender);
        expect(cubit.sessionNouns.length, 1);
      },
    );

    blocTest<NounsCubit, NounsState>(
      'emits NounsLoadingError if the repository throws during load',
      setUp: () {
        when(() => mockRepository.load()).thenThrow(Exception(''));
      },
      build: () => cubit,
      act: (cubit) => cubit.load(),
      expect: () => [isA<NounsLoading>(), isA<NounsLoadingError>()],
    );

    blocTest<NounsCubit, NounsState>(
      'emits NounsCorrect if the answer is correct and loads next noun',
      setUp: () {
        when(() => mockRepository.load()).thenAnswer(
          (_) async => feminineNoun,
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.validate(
        noun: feminineNoun,
        answer: Gender.feminine,
      ),
      expect: () =>
          [isA<NounsCorrect>(), isA<NounsLoading>(), isA<NounsLoaded>()],
    );

    blocTest<NounsCubit, NounsState>(
      'emits NounsIncorrect if the answer is incorrect',
      setUp: () {
        when(() => mockRepository.load()).thenAnswer(
          (_) async => feminineNoun,
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.validate(
        noun: feminineNoun,
        answer: Gender.masculine,
      ),
      expect: () => [isA<NounsIncorrect>()],
    );

    blocTest<NounsCubit, NounsState>(
      'does not emit for previous noun if session nouns is empty',
      build: () => cubit,
      act: (cubit) => cubit.previous(),
      verify: (cubit) => expect(cubit.state, isA<NounsInitial>()),
    );

    blocTest<NounsCubit, NounsState>(
      'emits NounsLoaded for the only noun in the session if there is only one',
      setUp: () {
        cubit.sessionNouns.add(feminineNoun);
      },
      build: () => cubit,
      act: (cubit) => cubit.previous(),
      expect: () => [isA<NounsLoading>(), isA<NounsLoaded>()],
      verify: (cubit) {
        final noun = (cubit.state as NounsLoaded).noun;
        expect(noun, feminineNoun);
      },
    );

    blocTest<NounsCubit, NounsState>(
      'emits NounsLoaded for last noun when previous is called',
      setUp: () {
        cubit.sessionNouns.addAll([feminineNoun, neuterNoun]);
      },
      build: () => cubit,
      act: (cubit) => cubit.previous(),
      expect: () => [isA<NounsLoading>(), isA<NounsLoaded>()],
      verify: (cubit) {
        final noun = (cubit.state as NounsLoaded).noun;
        expect(noun, neuterNoun);
      },
    );
  });
}
