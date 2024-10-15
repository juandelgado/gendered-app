import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/app/app.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:mocktail/mocktail.dart';

class MockNounsCubit extends MockCubit<NounsState> implements NounsCubit {}

void main() {
  group('App', () {
    testWidgets('renders Nouns page', (tester) async {
      final NounsCubit mockCubit = MockNounsCubit();
      when(mockCubit.load).thenAnswer(
        (_) async => {},
      );
      when(() => mockCubit.state).thenReturn(NounsInitial());

      await tester.pumpWidget(
        BlocProvider.value(
          value: mockCubit,
          child: const App(),
        ),
      );

      expect(find.byType(NounsPage), findsOneWidget);
    });
  });
}
