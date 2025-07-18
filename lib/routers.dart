import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_template/pages/auth/loginPage.dart';
import 'package:odc_mobile_template/pages/event/eventPage.dart';
import 'package:odc_mobile_template/pages/homeEvent/homeEventPage.dart';
import 'package:odc_mobile_template/pages/profil/profilPage.dart';
import 'pages/404/not_found_page.dart';
import 'pages/intro/appCtrl.dart';
import 'pages/intro/introPage.dart';
import 'utils/navigationUtils.dart';
import './main.dart';
import 'pages/home/homePage.dart';

final routerConfigProvider = Provider<GoRouter>((ref) {
  final navigatorKey = getIt<NavigationUtils>().navigatorKey;
  /*
   routes restreintes
  */
  final authRoutes = [
    GoRoute(
      path: "/app/home",
      name: 'home_page',
      builder: (ctx, state) {
        return EventPage();
      },
    ),
    GoRoute(
      path: "/app/events",
      name: 'events_page',
      builder: (ctx, state) => EventPage(),
    ),
    GoRoute(
      path: "/app/profile",
      name: 'profile_page',
      builder: (ctx, state) => ProfilPage(), // crée cette page si elle n'existe pas
    )
  ];

  /*
   routes publics
  */
  final noAuthRoutes = [
    GoRoute(
      path: "/public/intro",
      name: 'intro_page',
      builder: (ctx, state) {
        return LoginPage();
      },
    ),
  GoRoute(
  path: "/app/HomeEvent",
  name: 'HomeEvent_page',
  builder: (ctx, state) => HomeEventPage(), // crée cette page si elle n'existe pas
  )
  ];

  /*
CONFIGURATION  DES ROUTES
*/
  return GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: "/app/HomeEvent",
    redirect: (context, state) {
      var appState = ref.watch(appCtrlProvider);
      var user = appState.user;

      // redirection vers la page d'accueil si l'utilisateur est connecté
      if (user != null && state.matchedLocation.startsWith("/public")) {
        return "/app/home";
      }

      // redirection vers la page d'intro si l'utilisateur n'est pas connecté
      /*if (user == null && state.matchedLocation.startsWith("/app")) {
        return "/public/intro";
      }*/

      return null;
    },
    routes: [...noAuthRoutes, ...authRoutes],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});
