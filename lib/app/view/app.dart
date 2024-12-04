import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/app/app_routes.dart';
import 'package:gendered/app/cubit/language_cubit.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/ui/app_theme.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(routes: $appRoutes);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
