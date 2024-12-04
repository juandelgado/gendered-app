import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/licenses/cubit/licenses_cubit.dart';
import 'package:gendered/licenses/licenses.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../helpers/a11y.dart';
import '../../helpers/pump_app.dart';

class MockLicensesCubit extends MockCubit<LicensesState>
    implements LicensesCubit {}

void main() {
  group('LincensesView', () {
    late LicensesCubit mockCubit;
    final packageInfo = PackageInfo(
      appName: 'appName',
      packageName: 'packageName',
      version: 'version',
      buildNumber: 'buildNumber',
    );

    setUpAll(() {
      mockCubit = MockLicensesCubit();
    });

    testWidgets('renders loading by default', (tester) async {
      when(
        () => mockCubit.state,
      ).thenReturn(LicensesInitial());

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const LincensesView(),
        ),
      );

      expect(find.byType(LicensesLoadingWidget), findsOneWidget);
      await tester.a11yCheck();
    });

    testWidgets('renders loading for LicensesLoading', (tester) async {
      when(
        () => mockCubit.state,
      ).thenReturn(LicensesLoading());

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const LincensesView(),
        ),
      );

      expect(find.byType(LicensesLoadingWidget), findsOneWidget);
      await tester.a11yCheck();
    });

    testWidgets('renders error for LicensesError', (tester) async {
      when(
        () => mockCubit.state,
      ).thenReturn(LicensesError());

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const LincensesView(),
        ),
      );

      expect(find.byType(LicensesErrorWidget), findsOneWidget);
      await tester.a11yCheck();
    });

    testWidgets('renders LicensePage for LicensesLoaded', (tester) async {
      when(
        () => mockCubit.state,
      ).thenReturn(LicensesLoaded(info: packageInfo));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const LincensesView(),
        ),
      );

      expect(find.byType(LicensePage), findsOneWidget);
      expect(find.text(packageInfo.appName), findsOneWidget);
      expect(find.text(packageInfo.version), findsOneWidget);
    });
  });
}
