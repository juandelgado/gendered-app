import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gendered/model/gender.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension GenderX on AppLocalizations {
  String getGender(Gender gender) {
    switch (gender) {
      case Gender.masculine:
        return masculine;
      case Gender.feminine:
        return feminine;
      case Gender.neuter:
        return neuter;
    }
  }
}
