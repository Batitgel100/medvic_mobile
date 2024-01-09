import 'dart:convert';


import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';

class CreateInventoryLineApiClient {
  Future create(int productId, int locationId, int inventoryId, double qty,
      int prodLotId, int packageId, BuildContext context) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request = http.Request(
        'POST', Uri.parse('${AppUrl.baseUrl}/api/stock.inventory.line'));

    var requestBody = {
      "product_id": productId,
      "location_id": locationId,
      "inventory_id": inventoryId,
      "product_qty": qty,
      "prod_lot_id": prodLotId,
      "package_id": null,
    };

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Utils.flushBarSuccessMessage('Амжилттай нэмэгдлээ', context);

      print(await response.stream.bytesToString());
    } else {
      print('Error: ${response.reasonPhrase}');
      Utils.flushBarErrorMessage('Алдаа заалаа', context);

      print(await response.stream.bytesToString());
    }
  }
}
