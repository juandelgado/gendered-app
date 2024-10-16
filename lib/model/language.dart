import 'package:equatable/equatable.dart';
import 'package:gendered/model/gender.dart';

class Language with EquatableMixin {
  Language({
    required this.name,
    required this.locale,
    required this.flag,
    required this.genders,
  });

  final String name;
  final String locale;
  final String flag;
  final List<Gender> genders;

  @override
  List<Object> get props => [name, locale, flag, genders];
}

class German extends Language {
  German({
    super.name = 'Deutsch',
    super.locale = 'de',
    super.flag = '🇩🇪',
    super.genders = const [Gender.feminine, Gender.neuter, Gender.masculine],
  });
}
