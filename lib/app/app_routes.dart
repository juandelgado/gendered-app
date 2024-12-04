import 'package:flutter/material.dart';
import 'package:gendered/nouns/view/nouns_page.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

// good practices:
// https://engineering.verygood.ventures/navigation/navigation/

@TypedGoRoute<HomePageRoute>(
  path: '/',
  name: 'home',
  routes: [TypedGoRoute<LincensesPageRoute>(path: 'licenses')],
)
@immutable
class HomePageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => NounsPage();
}

@immutable
class LincensesPageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LicensePage();
}
