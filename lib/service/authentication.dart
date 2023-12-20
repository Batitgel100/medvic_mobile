// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/employe_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> login(
      String username, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://medvic.mn/api/auth/get_tokens?username=$username&password=$password'),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);
        final userId = jsonData['uid'];
        final accessToken = jsonData['access_token'];
        final latitude = jsonData['location'][0]['latitude'];
        final longitude = jsonData['location'][0]['longitude'];

        final timer = jsonData['expires_in'];

        Globals.changeUserId(userId);
        Globals.changebaseUrl('medvic.mn');
        Globals.changeRegister(accessToken);
        Globals.changelat(longitude);
        Globals.changelong(latitude);
        Globals.changeTimer(timer);
        await getEmployeeData();
        // print('${Globals.getlat()},${Globals.getlong()}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<EmployeeDataEntity?> getEmployeeData() async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var response = await http.get(
      Uri.parse(
          'http://medvic.mn/api/hr.employee.public?filters=[["user_id", "=", ${Globals.getUserId()}]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final String username = results[0]['name'];
      Globals.changeUserName(username);
      print('tiiinmeeee');
    }
    return null;
  }
}
