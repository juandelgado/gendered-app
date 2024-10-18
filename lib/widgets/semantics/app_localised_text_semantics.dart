import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/app/cubit/language_cubit.dart';

class AppLocalisedTextSemantics extends StatelessWidget {
  const AppLocalisedTextSemantics({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final language = context.read<LanguageCubit>().state;

    return Semantics(
      textDirection: language.textDirection,
      attributedValue: AttributedString(
        text,
        attributes: [
          LocaleStringAttribute(
            range: TextRange(start: 0, end: text.length),
            locale: language.locale,
          ),
        ],
      ),
      child: ExcludeSemantics(
        child: Text(text),
      ),
    );
  }
}
