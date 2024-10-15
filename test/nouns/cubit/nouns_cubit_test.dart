import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/repository/nouns_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNounsRepository extends Mock implements NounsRepository {}

const feminineNoun = Noun(name: 'lol', gender: Gender.feminine);

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
  });
}
