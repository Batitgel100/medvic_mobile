import 'dart:async';

import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/components/custom_drawer.dart';
import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/employe_data_entity.dart';
import 'package:erp_medvic_mobile/service/attendance_list_repo.dart';
import 'package:erp_medvic_mobile/service/company_name_repo.dart';
import 'package:erp_medvic_mobile/service/register_attendance.dart';
import 'package:erp_medvic_mobile/service/settings_repo.dart';
import 'package:erp_medvic_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceRegisterScreen extends StatefulWidget {
  const AttendanceRegisterScreen({super.key});

  @override
  State<AttendanceRegisterScreen> createState() =>
      _AttendanceRegisterScreenState();
}

class _AttendanceRegisterScreenState extends State<AttendanceRegisterScreen> {
  var desiredLocation = LatLng(Globals.getlong(), Globals.getlat());
  double desiredRadius = 50.0;
  RegisterAttendance registerAttendance = RegisterAttendance();
  TodayWorkedHoursApiClient todayWorkedHourApiClient =
      TodayWorkedHoursApiClient();
  RegisterAttendanceLeft registerLeft = RegisterAttendanceLeft();
  EmployeDataApiClient employe = EmployeDataApiClient();
  bool isInLocation = false;
  DateTime end = DateTime.now();
  DateTime start30 = DateTime.now();
  bool cameRegistered = false;
  late Timer inactivityTimer;
  int storedId = 0;
  CompanyNameRepository getcompany = CompanyNameRepository();

  @override
  void initState() {
    super.initState();
    getcompany.getCompanyName();
    startInactivityTimer();
    employe.getEmployeeData();
    _handleLocationPermission();
    checkLocation();
    getDate();
    _loadId();
    _onRefresh();
    getcompany.getCompanyName();
  }

  void startInactivityTimer() {
    inactivityTimer = Timer(
      Duration(seconds: Globals.getTimer()),
      () {
        Navigator.pushReplacementNamed(
          context,
          RoutesName.login,
        );
      },
    );
  }

  Future<void> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedId = prefs.getInt('stored_id') ?? 0;
    });
    Globals.changeregid(storedId);
  }

// 30 өдөрийн өмнөх өдөр аль өдөр вэ?

  void getDate() {
    DateTime currentDate = DateTime.now();

    DateTime startDate30 = currentDate.subtract(const Duration(days: 30));

    DateTime endDate = currentDate;

    setState(() {
      start30 = startDate30;
      end = endDate;
    });
  }

  // Апп байршил тогтоох эрхийг нээсэн эсэхийг шалгах

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

// Байршил шалгах

  Future<void> checkLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      desiredLocation.latitude,
      desiredLocation.longitude,
    );
    if (distance < 100) {
      isInLocation = true;
      setState(() {});
    } else {
      isInLocation = false;
    }
  }

  bool _refreshData = false;
//Ирц бүртгэх

  void onCame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ирсэнээр бүргүүлэх үү?'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        registerCame();
                        setState(() {});
                        _onRefresh();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.mainColor),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20),
                            child: Text(
                              'Тийм',
                              style: TextStyles.white17semibold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            'Үгүй',
                            style: TextStyles.red17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void registerCame() {
    if (isInLocation == false) {
      registerAttendance.register(context);
      //   // Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);
    } else {
      Utils.flushBarErrorMessage('Хол зайтай байна.', context);
    }
  }

//явсан ирц бүртгэх
  void registerLeeave() {
    if (Globals.getregid() == 0) {
      Utils.flushBarErrorMessage('Ирсэн цаг бүргэгдээгүй байна.', context);
    } else {
      registerLeft.register(context);
      // Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);
    }
  }

  void onLeft() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Явсанаар бүргүүлэх үү?',
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          registerLeeave();
                          setState(() {});
                          _onRefresh();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.mainColor),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20),
                              child: Text(
                                'Тийм',
                                style: TextStyles.white17semibold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'Үгүй',
                              style: TextStyles.red17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // behavior: HitTestBehavior.translucent,
      // onTap: () {
      //   resetInactivityTimer();
      // },
      // onPanUpdate: (details) {
      //   resetInactivityTimer();
      // },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
        ),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildName(),
                  _buildThirtyDay(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, bottom: 10, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'ӨНӨӨДРИЙН ИРЦ',
                          style: TextStyles.black19,
                        ),
                      ],
                    ),
                  ),
                  _buildTodayWorkedHours(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSmallButton(
                          0.06, 0.37, onCame, AppColors.white, 'Ирсэн'),
                      _buildSmallButton(
                          0.06, 0.37, onLeft, AppColors.white, 'Явсан'),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshData = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _refreshData = false;
    });
  }

  bool dataRefresh = true;
  FutureBuilder<void> _buildTodayWorkedHours() {
    return FutureBuilder<Map<String, dynamic>>(
      future: todayWorkedHourApiClient.fetchAttendanceData(),
      builder: (context, snapshot) {
        dataRefresh
            ? Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  dataRefresh = false;
                });
              })
            : null;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              _buildLoadingIndicator(context),
              _buildLoadingIndicator(context),
            ],
          );
        } else if (snapshot.hasError) {
          return _buildLoadingIndicator(context);
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Мэдээлэл байхгүй'));
        } else {
          final data = snapshot.data;
          final checkIn = data!['check_in'] ?? '0000-00-00 00:00:00';
          dynamic checkOut = data['check_out'] ?? '0000-00-00 00:00:00';
          DateTime now = DateTime.now();
          DateTime checkInDateTime = DateTime.parse(checkIn);
          var formatter = DateFormat('HH:mm');

          checkInDateTime = checkInDateTime.add(const Duration(hours: 8));
          String formattedCheckIn = formatter.format(checkInDateTime);

          DateTime checkOutDateTime = checkOut is DateTime
              ? checkOut
              : DateTime.parse(checkOut.toString());
          String formattedCheckOut =
              formatter.format(checkOutDateTime.add(const Duration(hours: 8)));
          checkOutDateTime = checkOutDateTime.add(const Duration(hours: 0));

          if (checkInDateTime.year == now.year &&
              checkInDateTime.month == now.month &&
              checkInDateTime.day == now.day) {
            cameRegistered = true;
          } else {
            cameRegistered = false;
          }

          return cameRegistered
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.mainColor,
                        ),
                        child: Center(
                            child: _refreshData
                                ? const CircularProgressIndicator(
                                    color: AppColors.white,
                                  )
                                : Text(
                                    'Ирсэн цаг: $formattedCheckIn',
                                    style: TextStyles.white22,
                                  )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.mainColor,
                        ),
                        child: Center(
                          child: _refreshData
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Text(
                                  'Явсан цаг: ${formattedCheckOut == '08:00' ? "бүртгэл хийгдээгүй" : formattedCheckOut}',
                                  style: TextStyles.white22,
                                ),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.mainColor,
                    ),
                    child: Center(
                      child: _refreshData
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                            )
                          : const Text(
                              'бүртгэл хийгдээгүй',
                              style: TextStyles.white22,
                            ),
                    ),
                  ),
                );
        }
      },
    );
  }

  Padding _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mainColor,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  FutureBuilder<double> _buildThirtyDay() {
    return FutureBuilder<double>(
      future: AttendanceListApiClients().getTotalWorkedHours(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator(context);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return _buildLoadingIndicator(context);
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          double totalWorkedHours = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.075,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mainColor,
              ),
              child: Center(
                child: _refreshData
                    ? const CircularProgressIndicator(
                        color: AppColors.white,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          '30 Хоногийн ирц: ${totalWorkedHours.toStringAsFixed(2)} цаг',
                          style: TextStyles.white22,
                        ),
                      ),
              ),
            ),
          );
        }
      },
    );
  }

  Padding _buildDate(BuildContext context, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.mainColor),
        child: Center(
          child: Text(formattedDate, style: TextStyles.white22),
        ),
      ),
    );
  }

  Padding _buildName() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: FutureBuilder<EmployeeDataEntity?>(
        future: EmployeDataApiClient().getEmployeeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator(context);
          } else if (snapshot.hasError) {
            return const Text(
              'Интернэт холболтоо шалгана уу!',
              style: TextStyles.black17,
            );
          } else if (snapshot.hasData) {
            final employee = snapshot.data!;

            return Container(
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.mainColor),
              child: Center(
                child: Text(
                  employee.name.toString(),
                  style: TextStyles.white22,
                ),
              ),
            );
          } else {
            return const Text('No employee data available');
          }
        },
      ),
    );
  }

  Padding _buildSmallButton(double height, double width, VoidCallback ontap,
      Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: ontap,
        child: Container(
          height: MediaQuery.of(context).size.height * height,
          width: MediaQuery.of(context).size.width * width * 0.95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,
              boxShadow: const [BoxShadows.shadow3]),
          child: Center(
            child: Text(
              text,
              style: TextStyles.main17semibold,
            ),
          ),
        ),
      ),
    );
  }
}
