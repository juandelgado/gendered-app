import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/nouns/cubit/nouns_cubit.dart';
import 'package:gendered/nouns/view/nouns_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE (JD): optional cubit to enable testing
    final cubit = context.read<NounsCubit?>();

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NounsPage(
        cubit: cubit,
      ),
    );
  }
}
