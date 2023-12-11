import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/test2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RoutesName.login,
      home: WorkedHoursWidget(),
    );
  }
}
