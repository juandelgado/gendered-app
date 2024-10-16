import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE (JD): optional cubit to enable testing
    final nounsCubit = context.read<NounsCubit?>();

    // https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#overriding-the-locale

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (context) => LanguageCubit(),
        child: Builder(
          builder: (context) {
            // NOTE we override the locale because regardless of the
            // locale of the device, we want the interface
            // set to the locale defined in the app
            final appLocale = context.read<LanguageCubit>().state.locale;

            return Localizations.override(
              context: context,
              locale: Locale(appLocale),
              child: Builder(
                builder: (context) {
                  return NounsPage(
                    cubit: nounsCubit,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
