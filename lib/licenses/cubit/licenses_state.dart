part of 'licenses_cubit.dart';

sealed class LicensesState extends Equatable {
  const LicensesState();

  @override
  List<Object> get props => [];
}

final class LicensesInitial extends LicensesState {}

final class LicensesLoading extends LicensesState {}

final class LicensesLoaded extends LicensesState {
  const LicensesLoaded({
    required this.info,
  });

  final PackageInfo info;

  @override
  List<Object> get props => [info];
}

final class LicensesError extends LicensesState {}
