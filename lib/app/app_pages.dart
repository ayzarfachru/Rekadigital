import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/connectivity/connectivity_page.dart';
import '../modules/home/home_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;
  static const INITIALOFFLINE = Routes.CONNECTIVITY;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.CONNECTIVITY,
      page: () => ConnectivityPage(),
    ),
  ];
}