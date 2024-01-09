import 'dart:convert';
import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/employe_data_entity.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${AppUrl.baseUrl}/api/auth/get_tokens?username=$username&password=$password'),
        body: {
          'username': username,
          'password': password,
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);

        final userId = jsonData['uid'];
        final accessToken = jsonData['access_token'];
        final expiresInSeconds = jsonData['expires_in'];
        print('User ID: $userId');
        print('Access Token: $accessToken');
        Globals.changeUserId(userId);
        Globals.changeRegister(accessToken);
        Globals.changeTimer(expiresInSeconds);

        // Perform other actions with the obtained data

        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
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
