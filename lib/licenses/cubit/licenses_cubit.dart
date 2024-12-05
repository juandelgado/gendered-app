import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'licenses_state.dart';

class LicensesCubit extends Cubit<LicensesState> {
  LicensesCubit({PackageInfoProvider? provider}) : super(LicensesInitial()) {
    _provider = provider ?? PackageInfoProvider();
  }

  late PackageInfoProvider _provider;

  Future<void> load() async {
    emit(LicensesLoading());
    try {
      final info = await _provider.load();
      emit(LicensesLoaded(info: info));
    } catch (e) {
      log(e.toString());
      emit(LicensesError());
    }
  }
}

class PackageInfoProvider {
  Future<PackageInfo> load() async {
    return PackageInfo.fromPlatform();
  }
}
