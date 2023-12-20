import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/service/attendance_list_repo.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Attendance> attendanceList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var data = await ApiProvider.getAttendanceList();
      setState(() {
        attendanceList = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      // Handle error gracefully, show an error message to the user, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(''),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: isLoading
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 80),
                      itemCount: attendanceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final record = attendanceList[index];
                        return _buildCard(
                          record.checkIn == null
                              ? ''
                              : record.checkIn.toString(),
                          'Ирсэн -',
                          'Явсан -',
                          record.checkOut == null
                              ? ''
                              : record.checkOut.toString(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildCard(
    String cameDay,
    String textcame,
    String textgone,
    String? goneHour,
  ) {
    String? formatDateTime(String? dateTimeString) {
      if (dateTimeString == null) {
        textgone = '';
        return 'Бүртгээгүй';
      }

      try {
        final DateTime parsedDateTime = DateTime.parse(dateTimeString).add(
          const Duration(hours: 8),
        );

        final formattedTime = DateFormat('HH:mm').format(parsedDateTime);
        return formattedTime;
      } catch (e) {
        return 'бүртгэгдээгүй'; // Return an error message if parsing fails
      }
    }

    final formattedDateTime = DateFormat('yyyy-M-d').format(
      DateTime.parse(cameDay).add(
        const Duration(hours: 8),
      ),
    );
    final formattedTime = DateFormat('HH:mm').format(
      DateTime.parse(cameDay).add(
        const Duration(hours: 8),
      ),
    );

    String? formattedGone =
        goneHour != null.toString() ? formatDateTime(goneHour) : 'Бүртгээгүй';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.09,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.mainColor,
            ),
            child: Center(
              child: Text(
                formattedDateTime,
                style: TextStyles.white23,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.secondaryColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: .0),
                    child: Text(
                      '$textcame $formattedTime',
                      style: TextStyles.white17,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.secondaryColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      '$textgone ${formattedGone!}',
                      style: TextStyles.white17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
