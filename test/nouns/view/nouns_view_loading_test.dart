import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

void main() {
  group('NounsViewLoading', () {
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
  });
}
