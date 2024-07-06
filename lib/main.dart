import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'config/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: Typography().white.apply(fontFamily: 'Spartan MB'),
      ),
      getPages: Routes.appRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
