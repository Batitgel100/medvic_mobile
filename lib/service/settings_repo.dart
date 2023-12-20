import 'dart:convert';

import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/employe_data_entity.dart';
import 'package:http/http.dart' as http;

class EmployeDataApiClient {
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
      final int id = results[0]['id'];
      final int companyId = results[0]['company_id'];
      final String username = results[0]['name'];
      Globals.changeUserName(username);
      Globals.changeEmployeeId(id);
      Globals.changeCompanyId(companyId);

      if (results.isNotEmpty) {
        return EmployeeDataEntity.fromJson(results[0]);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load employee data');
    }
  }
}
