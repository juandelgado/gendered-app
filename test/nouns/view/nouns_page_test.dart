import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../cubit/nouns_cubit_test.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

void main() {
  group('NounsPage', () {
    late MockNounsCubit mockCubit;

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
    });

    testWidgets('renders NounsViewIncorrect for NounsIncorrect',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(NounsIncorrect(noun: femenineNoun));
      when(() => mockCubit.load()).thenAnswer((_) async => {});

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );
      expect(find.byType(NounsViewIncorrect), findsOneWidget);

      await tester.tap(find.byKey(NounsViewIncorrect.nextKey));
      verify(() => mockCubit.load()).called(1);
    });

    testWidgets('renders NounsViewCorrect for NounsCorrect', (tester) async {
      when(() => mockCubit.state).thenReturn(NounsCorrect(noun: femenineNoun));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const NounsView(),
        ),
      );

      expect(find.byType(NounsViewCorrect), findsOneWidget);
    });
  });
}
