import 'package:erp_medvic_mobile/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyNameRepository {
  Future<void> getCompanyName() async {
    final String accessToken = Globals.getRegister().toString();
    final String companyId = Globals.getCompanyId().toString();
    final Uri uri = Uri.parse('http://medvic.mn/api/res.company/1');

    try {
      final response = await _makeGetRequest(uri, accessToken);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final String companyName = jsonData["name"] ?? 'Хоосон';
        Globals.changeCompany(companyName);
      } else {
        // print(
        //     'Failed to get company name. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to get company name: $e');
    }
  }

  Future<http.Response> _makeGetRequest(Uri uri, String accessToken) async {
    final headers = {'Access-token': accessToken};
    final response = await http.get(uri, headers: headers);
    return response;
  }
}
