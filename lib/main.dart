import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/app_binding.dart';
import 'app/app_pages.dart';
import 'modules/connectivity/connectivity_controller.dart';

void main() {
  final ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MyApp(),
  );
  connectivityController.startConnectivityCheck();
}

class MyApp extends StatelessWidget {
  final ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      initialRoute: connectivityController.isConnected.value
          ? AppPages.INITIAL
          : AppPages.INITIALOFFLINE,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
    );
  }
}
