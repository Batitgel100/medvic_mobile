import 'dart:convert';

import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/prod_lot_entity.dart';
import 'package:http/http.dart' as http;

class ProdLotApiClient {
  Future<List<ProdLotEntity>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}/api/stock.production.lot'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> resultsData = jsonData['results'];
      return resultsData.map((json) => ProdLotEntity.fromJson(json)).toList();
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
