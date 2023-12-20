// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static Future<List<Attendance>> getAttendanceList() async {
    var url = 'http://medvic.mn/api/hr.attendance';
    var headers = {
      'Access-token': Globals.getRegister(),
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Attendance> tempList = [];

      for (var entry in data['results']) {
        tempList.add(Attendance.fromJson(entry));
      }

      return tempList;
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}

class Attendance {
  final int id;
  final DateTime? checkIn;
  final DateTime? checkOut; // Make this property nullable
  final int? employeeId;
  final double? workedHours;

  Attendance({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.employeeId,
    required this.workedHours,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      checkIn: DateTime.parse(json['check_in']),
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out'])
          : null, // Handle null check
      employeeId: json['employee_id'],
      workedHours: json['worked_hours'],
    );
  }
}

class AttendanceListApiClients {
  Future<double> getTotalWorkedHours() async {
    var headers = {'Access-token': Globals.getRegister()};

    var response = await http
        .get(Uri.parse('http://medvic.mn/api/hr.attendance'), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> attendanceData = json.decode(response.body);
      List<Map<String, dynamic>> records = List.from(attendanceData['results']);

      DateTime thirtyDaysAgo =
          DateTime.now().subtract(const Duration(days: 30));
      List<Map<String, dynamic>> filteredRecords = records.where((record) {
        DateTime checkIn = DateTime.parse(record['check_in']);
        return checkIn.isAfter(thirtyDaysAgo);
      }).toList();

      double totalWorkedHours = 0.0;
      for (var record in filteredRecords) {
        totalWorkedHours += record['worked_hours'];
      }

      return double.parse(totalWorkedHours.toString());
    } else {
      throw Exception(
          'Failed to fetch attendance data. Status code: ${response.statusCode}');
    }
  }
}

class TodayWorkedHoursApiClient {
  Future<Map<String, dynamic>> fetchAttendanceData() async {
    var headers = {'Access-token': Globals.getRegister()};
    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/hr.attendance?filters=[["employee_id", "=", ${Globals.getEmployeeId()}]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data.containsKey('results') &&
          data['results'] is List<dynamic> &&
          data['results'].isNotEmpty) {
        return data['results'][0];
      }
    }
    throw Exception('Failed to load today data');
  }
}
