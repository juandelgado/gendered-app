import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/extensions/string_extensions.dart';
import 'package:gendered/extensions/theme_extensions.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/widgets/app_buttons.dart';
import 'package:gendered/widgets/app_svg_icon.dart';
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

    return BlocBuilder<NounsCubit, NounsState>(
      builder: (context, state) {
        final noun = (state is NounStateWithNoun) ? state.noun : null;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Builder(
                  builder: (context) {
                    switch (state.runtimeType) {
                      case NounsCorrect:
                        return NounsViewCorrect(noun: noun!);
                      case NounsIncorrect:
                        return NounsViewIncorrect(
                          noun: noun!,
                          attempt: (state as NounsIncorrect).attempt,
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
                        return NounsViewLoaded(
                          noun: noun!,
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
              ),
            ),
          ),
          bottomNavigationBar: NounsBottomBar(
            onGenderSelected: noun == null || state is NounsCorrect
                ? null
                : (anwswer) {
                    context
                        .read<NounsCubit>()
                        .validate(noun: noun, answer: anwswer);
                  },
            onNextNoun: noun == null || state is NounsCorrect
                ? null
                : () {
                    context.read<NounsCubit>().load();
                  },
            onPreviousNoun: noun == null || state is NounsCorrect
                ? null
                : () {
                    context.read<NounsCubit>().previous();
                  },
          ),
        );
      },
    );
  }
}

class NounsBottomBar extends StatelessWidget {
  const NounsBottomBar({
    required this.onGenderSelected,
    required this.onNextNoun,
    required this.onPreviousNoun,
    super.key,
  });

  final ValueChanged<Gender>? onGenderSelected;
  final VoidCallback? onNextNoun;
  final VoidCallback? onPreviousNoun;
  static const Key previousKey = Key('NounsBottomBarPrevious');
  static const Key nextKey = Key('NounsBottomBarNext');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = context.read<LanguageCubit>().state;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (index, gender) in language.genders.indexed)
                  Padding(
                    padding: EdgeInsets.only(
                      right: index < language.genders.length - 1 ? 24 : 0,
                    ),
                    child: CircularTextButton(
                      key: Key('selectGender${gender.name.capitalize()}'),
                      hint: l10n.set_as_gender(l10n.getGender(gender)),
                      text:
                          l10n.getGender(gender).substring(0, 1).toUpperCase(),
                      style: textTheme.headlineLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                      width: 96,
                      height: 96,
                      onPressed: onGenderSelected == null
                          ? null
                          : () => onGenderSelected!(gender),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularWidgetButton(
                  key: previousKey,
                  hint: l10n.load_previous_noun,
                  onPressed: onPreviousNoun,
                  width: 72,
                  height: 72,
                  child: const AppSvgIcon(
                    assetPath: 'assets/icons/svg/arrow_back_24dp.svg',
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                CircularWidgetButton(
                  key: nextKey,
                  hint: l10n.load_next_noun,
                  onPressed: onNextNoun,
                  width: 72,
                  height: 72,
                  child: const AppSvgIcon(
                    assetPath: 'assets/icons/svg/arrow_forward_24dp.svg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NounsViewIncorrect extends StatelessWidget {
  const NounsViewIncorrect({
    required this.noun,
    required this.attempt,
    required this.onGenderSelected,
    required this.onNextNoun,
    super.key,
  });

  final Noun noun;
  final int attempt;
  final ValueChanged<Gender> onGenderSelected;
  final VoidCallback onNextNoun;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final incorrectText = l10n.incorrect_answer(attempt - 1);
    const maxBangs = 3;
    final bangs = '!' * min(maxBangs, attempt - 1);

    return Column(
      children: [
        NounsViewLoaded(noun: noun),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppWidgetSemantics(
              value: incorrectText,
              isLiveRegion: true,
              child: const AppSvgIcon(
                assetPath: 'assets/icons/svg/close_24dp.svg',
                width: 80,
                height: 80,
              ),
            ),
            Text(
              bangs,
              style: textTheme.displayLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
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
      children: [
        NounsViewLoaded(
          noun: noun,
        ),
        AppWidgetSemantics(
          value: l10n.correct_answer,
          isLiveRegion: true,
          child: const AppSvgIcon(
            assetPath: 'assets/icons/svg/check_24dp.svg',
            width: 100,
            height: 100,
          ),
        ),
      ],
    );
  }
}

class NounsViewLoaded extends StatelessWidget {
  const NounsViewLoaded({
    required this.noun,
    super.key,
  });

  final Noun noun;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        LocalisedNoun(
          noun: noun,
        ),
        const SizedBox(
          height: 24,
        ),
        for (final (index, definition) in noun.definitions.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LocalisedDefinition(
              index: index + 1,
              definition: definition,
            ),
          ),
      ],
    );
  }
}

class NounsViewLoading extends StatelessWidget {
  const NounsViewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AppWidgetSemantics(
        value: l10n.load_next_noun,
        isLiveRegion: true,
        child: const CircularProgressIndicator(),
      ),
    );
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
      children: [
        Text(l10n.something_went_wrong),
        PrimaryTextButton(
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
  const LocalisedNoun({
    required this.noun,
    super.key = const Key('localisedNoun'),
  });

  final Noun noun;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
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
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await context.read<LanguageCubit>().textToSpeech(text: noun.name);
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  noun.name,
                  style: textTheme.displayLarge
                      ?.copyWith(color: colorScheme.primary),
                ),
              ),
              Icon(
                Icons.volume_up,
                size: 96,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LocalisedDefinition extends StatelessWidget {
  const LocalisedDefinition({
    required this.index,
    required this.definition,
    super.key = const Key('localisedDefinition'),
  });

  final String definition;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final language = context.read<LanguageCubit>().state;
    final completeValue = l10n.reader_definition(index, definition);

    return Semantics(
      textDirection: language.textDirection,
      attributedValue: AttributedString(
        completeValue,
        attributes: [
          LocaleStringAttribute(
            range: TextRange(
              start: completeValue.length - definition.length,
              end: completeValue.length,
            ),
            locale: language.locale,
          ),
        ],
      ),
      child: ExcludeSemantics(
        child: Text(
          '\t $index: $definition',
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
