import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gendered/l10n/l10n.dart';
import 'package:gendered/licenses/cubit/licenses_cubit.dart';
import 'package:gendered/widgets/semantics/app_widget_semantics.dart';

// note: look into flutter_oss_licenses
// https://pub.dev/packages/flutter_oss_licenses

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LicensesCubit()..load(),
      child: const LincensesView(),
    );
  }
}

class LincensesView extends StatelessWidget {
  const LincensesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<LicensesCubit, LicensesState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case LicensesLoaded:
            final info = (state as LicensesLoaded).info;
            return LicensePage(
              applicationName: info.appName,
              applicationVersion: info.version,
              applicationLegalese: l10n.licenses_thanks,
            );
          case LicensesError:
            return const LicensesErrorWidget();
          default:
            return const LicensesLoadingWidget();
        }
      },
    );
  }
}

class LicensesLoadingWidget extends StatelessWidget {
  const LicensesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.licenses_title),
      ),
      body: AppWidgetSemantics(
        value: l10n.loading_licenses,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class LicensesErrorWidget extends StatelessWidget {
  const LicensesErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.licenses_title),
      ),
      body: AppWidgetSemantics(
        value: l10n.loading_licenses_error,
        child: const Center(
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}
