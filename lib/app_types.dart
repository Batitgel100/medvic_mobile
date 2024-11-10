import 'package:erp_medvic_mobile/screens/appointment/appointment_list_screen.dart';
import 'package:erp_medvic_mobile/screens/attendance%20register/attendance_list_screen.dart';
import 'package:erp_medvic_mobile/screens/attendance%20register/attendance_register_screen.dart';
import 'package:erp_medvic_mobile/screens/count/count_screen.dart';
import 'package:erp_medvic_mobile/screens/login/login_screen.dart';
import 'package:erp_medvic_mobile/screens/main/main_screen.dart';
import 'package:erp_medvic_mobile/screens/product/product_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.attendanceRegister:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const AttendanceRegisterScreen());

      case RoutesName.attendanceScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TestScreen());
      // builder: (BuildContext context) => const MyWidget());
      case RoutesName.countScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CountScreen());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.main:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen());
      case RoutesName.product:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProductScreen());

      case RoutesName.appointmentListScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AppointmentListScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}

class RoutesName {
  static const String attendanceRegister = 'attendanceRegister';
  static const String attendanceScreen = 'attendanceScreen';
  static const String countScreen = 'countScreen';
  static const String appointmentListScreen = 'appointmentListScreen';
  static const String login = 'login';
  static const String item = 'item';
  static const String product = 'product';

  //home screen routes name
  static const String main = 'main_screen';
}
