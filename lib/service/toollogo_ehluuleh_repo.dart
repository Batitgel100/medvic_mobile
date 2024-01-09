// ignore_for_file: avoid_print

import 'package:erp_medvic_mobile/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/app_url.dart';
import '../utils/utils.dart';

class ToollogoEhluulehApiClient {
  Future<void> toollogoEhluuleh(int id) async {
    final headers = {
      'Access-token': Globals.getRegister(),
    };

    final url =
        Uri.parse('${AppUrl.baseUrl}/api/stock.inventory/$id/action_start');

    final response = await http.put(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('амжилттай тооллого эхэлсэн');
    } else {
      print(response.reasonPhrase);
    }
  }
}

class ToollogoBatlahApiClient {
  Future<void> toollogoBatlah(int id, BuildContext context) async {
    final headers = {
      'Access-token': Globals.getRegister(),
    };

    final url =
        Uri.parse('${AppUrl.baseUrl}/api/stock.inventory/$id/action_validate');

    final response = await http.put(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('амжилттай тооллого batalsan');
    } else {
      Utils.flushBarErrorMessage(
          'Тооллогын баримтыг зөвхөн Агуулахын менежер эрхтэй хэрэглэгч батлах боломжтой.',
          context);
    }
  }
}
