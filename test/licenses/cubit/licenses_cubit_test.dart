import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/licenses/cubit/licenses_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockPackageInfoProvider extends Mock implements PackageInfoProvider {}

void main() {
  group('LicensesCubit', () {
    late PackageInfoProvider mockProvider;
    late LicensesCubit cubit;
    final packageInfo = PackageInfo(
      appName: 'appName',
      packageName: 'packageName',
      version: 'version',
      buildNumber: 'buildNumber',
    );

    setUp(() {
      mockProvider = MockPackageInfoProvider();
      cubit = LicensesCubit(provider: mockProvider);
    });

    test('initial state is LicensesInitial', () {
      expect(cubit.state, isA<LicensesInitial>());
    });

    blocTest<LicensesCubit, LicensesState>(
      'emits LicensesLoading and LicensesLoaded during load()',
      setUp: () {
        when(
          () => mockProvider.load(),
        ).thenAnswer(
          (_) async => packageInfo,
        );
      },
      build: () => cubit,
      act: (_) => cubit.load(),
      expect: () => [isA<LicensesLoading>(), isA<LicensesLoaded>()],
      verify: (_) {
        final actualPackageInfo = (cubit.state as LicensesLoaded).info;
        expect(actualPackageInfo, equals(packageInfo));
      },
    );

    blocTest<LicensesCubit, LicensesState>(
      'emits LicensesLoading and LicensesError if provider.load() throws',
      setUp: () {
        when(
          () => mockProvider.load(),
        ).thenThrow(Exception(''));
      },
      build: () => cubit,
      act: (_) => cubit.load(),
      expect: () => [isA<LicensesLoading>(), isA<LicensesError>()],
    );
  });
}
