import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:gendered/ui/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    // NOTE (JD): optional cubit to enable testing
    final nounsCubit = context.read<NounsCubit?>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (context) => LanguageCubit(),
        child: Builder(
          builder: (context) {
            return Builder(
              builder: (context) {
                return NounsPage(
                  cubit: nounsCubit,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
