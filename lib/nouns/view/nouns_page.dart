import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/model/genre.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';

class NounsPage extends StatelessWidget {
  NounsPage({super.key, NounsCubit? cubit}) {
    _nounsCubit = cubit ??= NounsCubit();
  }

  late final NounsCubit _nounsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _nounsCubit.load();
        return _nounsCubit;
      },
      child: const NounsView(),
    );
  }
}

class NounsView extends StatelessWidget {
  const NounsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouns'),
      ),
      body: BlocBuilder<NounsCubit, NounsState>(
        builder: (context, state) {
          return Center(
            child: Builder(
              builder: (context) {
                switch (state.runtimeType) {
                  case NounsCorrect:
                    final noun = (state as NounsCorrect).noun;
                    return NounsViewCorrect(noun: noun);
                  case NounsIncorrect:
                    final noun = (state as NounsIncorrect).noun;
                    return NounsViewIncorrect(
                      noun: noun,
                      onGenreSelected: (genre) {
                        context
                            .read<NounsCubit>()
                            .validate(noun: noun, answer: genre);
                      },
                      onNextNoun: () {
                        context.read<NounsCubit>().load();
                      },
                    );
                  case NounsLoaded:
                    final noun = (state as NounsLoaded).noun;
                    return NounsViewLoaded(
                      noun: noun,
                      onGenreSelected: (genre) {
                        context
                            .read<NounsCubit>()
                            .validate(noun: noun, answer: genre);
                      },
                    );
                  case NounsLoadingError:
                    return NounsViewLoadingError(
                      onTryAgain: () {
                        context.read<NounsCubit>().load();
                      },
                    );
                  default:
                    return const NounsViewLoading();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class NounsViewIncorrect extends StatelessWidget {
  const NounsViewIncorrect({
    required this.onNextNoun,
    required this.noun,
    required this.onGenreSelected,
    super.key,
  });

  final Noun noun;
  final ValueChanged<Genre> onGenreSelected;
  final VoidCallback onNextNoun;
  static const Key nextKey = Key('NounsViewIncorrectNext');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('❌'),
        NounsViewLoaded(noun: noun, onGenreSelected: onGenreSelected),
        ElevatedButton(
          key: nextKey,
          onPressed: onNextNoun,
          child: const Text('Next'),
        ),
      ],
    );
  }
}

class NounsViewCorrect extends StatelessWidget {
  const NounsViewCorrect({required this.noun, super.key});

  final Noun noun;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('✅'),
        NounsViewLoaded(
          noun: noun,
        ),
      ],
    );
  }
}

class NounsViewLoaded extends StatelessWidget {
  const NounsViewLoaded({
    required this.noun,
    this.onGenreSelected,
    super.key,
  });

  final Noun noun;
  final ValueChanged<Genre>? onGenreSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(noun.name),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onGenreSelected == null
                  ? null
                  : () => onGenreSelected!(Genre.femenine),
              child: Text(
                Genre.femenine.name,
              ),
            ),
            ElevatedButton(
              onPressed: onGenreSelected == null
                  ? null
                  : () => onGenreSelected!(Genre.neuter),
              child: Text(
                Genre.neuter.name,
              ),
            ),
            ElevatedButton(
              onPressed: onGenreSelected == null
                  ? null
                  : () => onGenreSelected!(Genre.masculine),
              child: Text(
                Genre.masculine.name,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NounsViewLoading extends StatelessWidget {
  const NounsViewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class NounsViewLoadingError extends StatelessWidget {
  const NounsViewLoadingError({required this.onTryAgain, super.key});

  static const Key tryAgainKey = Key('NounsViewLoadingErrorTryAgain');

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Something went wrong'),
        ElevatedButton(
          key: tryAgainKey,
          onPressed: onTryAgain,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}
