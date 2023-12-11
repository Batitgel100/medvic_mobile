import 'package:erp_medvic_mobile/screens/attendance%20register/attendance_register_screen.dart';
import 'package:erp_medvic_mobile/screens/settings/settings_screen.dart';
import 'package:erp_medvic_mobile/service/settings_repo.dart';
import 'package:flutter/material.dart';

import '../../service/company_name_repo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  EmployeDataApiClient employee = EmployeDataApiClient();
  CompanyNameRepository companyName = CompanyNameRepository();
  @override
  void initState() {
    super.initState();
    getEmployee();
    companyName.getCompanyName();
  }

  void getEmployee() {
    employee.getEmployeeData();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    // const HomeScreen(),
    const AttendanceRegisterScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          unselectedItemColor: const Color.fromARGB(255, 144, 143, 143),
          elevation: 20,
          currentIndex: _selectedIndex,
          iconSize: 25,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.home),
            //   label: 'Нүүр хуудас',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Ирц бүртгэл',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Тохиргоо',
            ),
          ],
        ),
      ),
    );
  }
}
