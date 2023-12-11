import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkedHoursWidget extends StatefulWidget {
  const WorkedHoursWidget({super.key});

  @override
  _WorkedHoursWidgetState createState() => _WorkedHoursWidgetState();
}

class _WorkedHoursWidgetState extends State<WorkedHoursWidget> {
  double totalWorkedHours = 0.0;

  @override
  void initState() {
    super.initState();
    // Fetch and set the total worked hours when the widget is created
    fetchAndDisplayHours();
  }

  Future<void> fetchAndDisplayHours() async {
    var headers = {'Access-token': 'd7493aec4199983ab358bcf65f956dd73affd52a'};
    var url = 'http://medvic.mn/api/hr.attendance';

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];

      DateTime thirtyDaysAgo =
          DateTime.now().subtract(const Duration(days: 30));

      double totalHours = 0.0;

      for (var entry in data) {
        DateTime checkIn = DateTime.parse(entry['check_in']);
        if (checkIn.isAfter(thirtyDaysAgo)) {
          DateTime checkOut = DateTime.parse(entry['check_out']);
          double hoursWorked = entry['worked_hours'];
          totalHours += hoursWorked;
        }
      }

      print('Total hours in the last 30 days: $totalHours');
      // Now you can update your UI with the totalHours value.
    } else {
      print('Failed to fetch data. ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total Worked Hours in the Last 30 Days:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalWorkedHours hours',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
