import 'dart:convert';

import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/inventory_line_entity.dart';
import 'package:http/http.dart' as http;

class InventoryLineApiClient {
  Future<List<InventoryLineEntity>> fetchData() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse('${AppUrl.baseUrl}/api/stock.inventory.line'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> resultsData = jsonData['results'];
      print('success');
      return resultsData
          .map((json) => InventoryLineEntity.fromJson(json))
          .toList();
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
