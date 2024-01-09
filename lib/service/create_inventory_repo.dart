import 'dart:convert';

import 'package:erp_medvic_mobile/constant/app_url.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';

class CreateInventoryApiClient {
  Future create(String inventoryName, List<Map<String, int>> productIds,
      List<Map<String, int>> locationIds) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request = http.Request(
        'POST', Uri.parse('${AppUrl.baseUrl}/api/stock.inventory'));

    var requestBody = {
      "name": inventoryName,
      "company_id": Globals.getCompanyId(),
      "state": "draft",
      "product_ids": productIds,
      "location_ids": locationIds,
    };

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(Globals.companyId);
    print(Globals.register);
    if (response.statusCode == 200) {
      // Utils.flushBarSuccessMessage('Амжилттай нэмэгдлээ', context);

      print(await response.stream.bytesToString());
    } else {
      print('Error: ${response.reasonPhrase}');
      print(await response.stream.bytesToString());
    }
  }
}
