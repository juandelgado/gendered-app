part of 'nouns_cubit.dart';

@immutable
sealed class NounsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class NounsInitial extends NounsState {}

final class NounsLoading extends NounsState {}

final class NounsLoadingError extends NounsState {}

final class NounsLoaded extends NounsState {
  NounsLoaded({required this.noun});

  final Noun noun;

  @override
  List<Object> get props => [noun];
}

final class NounsCorrect extends NounsState {
  NounsCorrect({required this.noun});

  final Noun noun;

  @override
  List<Object> get props => [noun];
}

final class NounsIncorrect extends NounsState {
  NounsIncorrect({required this.noun});

  final Noun noun;

  @override
  List<Object> get props => [noun];
}
