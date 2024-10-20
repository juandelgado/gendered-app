part of 'nouns_cubit.dart';

@immutable
sealed class NounsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class NounsInitial extends NounsState {}

final class NounsLoading extends NounsState {}

final class NounsLoadingError extends NounsState {}

final class NounStateWithNoun extends NounsState {
  NounStateWithNoun({required this.noun});

  final Noun noun;

  @override
  List<Object> get props => [noun];
}

final class NounsLoaded extends NounStateWithNoun {
  NounsLoaded({required super.noun});
}

final class NounsCorrect extends NounStateWithNoun {
  NounsCorrect({required super.noun});
}

final class NounsIncorrect extends NounStateWithNoun {
  NounsIncorrect({required super.noun});
}
