import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/extensions/string_extensions.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/widgets/app_buttons.dart';
import 'package:gendered/widgets/semantics/app_widget_semantics.dart';

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
    final language = context.read<LanguageCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(language.name),
            ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(language.flag),
              ),
            ),
          ],
        ),
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
                      onGenderSelected: (gender) {
                        context
                            .read<NounsCubit>()
                            .validate(noun: noun, answer: gender);
                      },
                      onNextNoun: () {
                        context.read<NounsCubit>().load();
                      },
                    );
                  case NounsLoaded:
                    final noun = (state as NounsLoaded).noun;
                    return NounsViewLoaded(
                      noun: noun,
                      onGenderSelected: (gender) {
                        context
                            .read<NounsCubit>()
                            .validate(noun: noun, answer: gender);
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
    required this.onGenderSelected,
    super.key,
  });

  final Noun noun;
  final ValueChanged<Gender> onGenderSelected;
  final VoidCallback onNextNoun;
  static const Key nextKey = Key('NounsViewIncorrectNext');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppWidgetSemantics(
          value: l10n.incorrect_answer,
          isLiveRegion: true,
          child: const Text('❌'),
        ),
        NounsViewLoaded(noun: noun, onGenderSelected: onGenderSelected),
        PrimaryButton(
          key: nextKey,
          onPressed: onNextNoun,
          text: l10n.next,
          hint: l10n.load_next_noun,
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
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppWidgetSemantics(
          value: l10n.correct_answer,
          isLiveRegion: true,
          child: const Text('✅'),
        ),
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
    this.onGenderSelected,
    super.key,
  });

  final Noun noun;
  final ValueChanged<Gender>? onGenderSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = context.read<LanguageCubit>().state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LocalisedNoun(
          noun: noun,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final gender in language.genders)
              PrimaryButton(
                key: Key('selectGender${gender.name.capitalize()}'),
                onPressed: onGenderSelected == null
                    ? null
                    : () => onGenderSelected!(gender),
                text: l10n.getGender(gender),
                hint: l10n.set_as_gender(l10n.getGender(gender)),
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
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.something_went_wrong),
        PrimaryButton(
          key: tryAgainKey,
          onPressed: onTryAgain,
          text: l10n.try_again,
          hint: l10n.try_again,
        ),
      ],
    );
  }
}

class LocalisedNoun extends StatelessWidget {
  const LocalisedNoun({required this.noun, super.key});

  final Noun noun;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = context.read<LanguageCubit>().state;
    final completeValue = l10n.reader_the_word_is(noun.name);

    return Semantics(
      textDirection: language.textDirection,
      attributedValue: AttributedString(
        completeValue,
        attributes: [
          LocaleStringAttribute(
            range: TextRange(
              start: completeValue.length - noun.name.length,
              end: completeValue.length,
            ),
            locale: language.locale,
          ),
        ],
      ),
      child: ExcludeSemantics(
        child: Text(noun.name),
      ),
    );
  }
}
