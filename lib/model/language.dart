import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gendered/model/gender.dart';

class Language with EquatableMixin {
  Language({
    required this.name,
    required this.locale,
    required this.localeString,
    required this.textDirection,
    required this.flag,
    required this.genders,
  });

  final String name;
  final String localeString;
  final Locale locale;
  final TextDirection textDirection;
  final String flag;
  final List<Gender> genders;

  @override
  List<Object> get props =>
      [name, localeString, locale, textDirection, flag, genders];
}

class German extends Language {
  German({
    super.name = 'Deutsch',
    super.localeString = 'de',
    super.locale = const Locale('de'),
    super.textDirection = TextDirection.ltr,
    super.flag = '🇩🇪',
    super.genders = const [Gender.feminine, Gender.neuter, Gender.masculine],
  });
}
