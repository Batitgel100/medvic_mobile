import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';

class QuantityUpdateApiClient {
  Future<void> qtyUpdate(int? id, String qty, BuildContext context) async {
    final headers = {
      'Access-token': Globals.getRegister(),
    };

    final url = Uri.parse('${AppUrl.baseUrl}/api/stock.inventory.line/$id');

    final response = await http.put(
      url,
      headers: headers,
      body: '''{\n    "product_qty":$qty\n}''',
    );

    if (response.statusCode == 200) {
      Utils.flushBarSuccessMessage('Амжилттай засагдлаа.', context);
    } else {
      print(response.body);
      Utils.flushBarErrorMessage('Амжилтгүй', context);
    }
  }
}

class TsuvralUpdateApiClient {
  Future<void> tsuvralUpdate(int? id, String qty, BuildContext context) async {
    final headers = {
      'Access-token': Globals.getRegister(),
    };

    final url = Uri.parse('${AppUrl.baseUrl}/api/stock.inventory.line/$id');

    final response = await http.put(
      url,
      headers: headers,
      body: '''{\n    "prod_lot_id":$qty\n}''',
    );

    if (response.statusCode == 200) {
      Utils.flushBarSuccessMessage('Амжилттай засагдлаа.', context);
    } else {
      print(response.body);
      Utils.flushBarErrorMessage('Амжилтгүй', context);
    }
  }
}
