import 'dart:convert';

import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/appointment_list.dart';
import 'package:erp_medvic_mobile/models/appointment_detail_list.dart';
import 'package:erp_medvic_mobile/models/appointment_model.dart';
import 'package:erp_medvic_mobile/models/zovuir_list.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AppointmentService {
  Future<AppointmentListModel> appointmentList() async {
    final response = await http.get(
        Uri.parse(
            'http://medvic.mn/api/medical.appointment?filters=["|","|",["is_gd","=",True],["is_gdf","=",True],["is_gd_hd","=",True],["state","=","app_start"]]'),
        headers: {
          'Access-token': Globals.getRegister(),
        });
    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return AppointmentListModel.fromJson(jsonData['results']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Appointment> appointmentFormDetail(int id) async {
    final response = await http.get(
        Uri.parse(
            'http://medvic.mn/api/medical.appointment?filters=["|","|",["is_gd","=",True],["is_gdf","=",True],["is_gd_hd","=",True],["state","=","app_start"],["id","=",$id]]'),
        headers: {
          'Access-token': Globals.getRegister(),
        });
    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonData['results'][0]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ZovuirListModel> zovuir() async {
    final response = await http
        .get(Uri.parse('http://erp.medvic.mn/api/stress.register'), headers: {
      'Access-token': Globals.getRegister(),
    });
    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return ZovuirListModel.fromJson(jsonData['results']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<AppointmentDetailListModel> appointmentDetail(int id) async {
    final response = await http.get(
        Uri.parse(
            'http://medvic.mn/api/weight.line.data?filters=[["appointment_id","=",$id]]'),
        headers: {
          'Access-token': Globals.getRegister(),
        });
    final Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      return AppointmentDetailListModel.fromJson(jsonData['results']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> daraltInsert(
      String weight,
      String preWeight,
      String o2Value,
      String pulse,
      String pulseOne,
      String pulseTwo,
      String temp,
      String finalKtv,
      String adPulse,
      int appointmentId) async {
    final response =
        await http.post(Uri.parse('http://medvic.mn/api/weight.line.data'),
            headers: {
              'Access-token': Globals.getRegister(),
            },
            body: jsonEncode({
              "weight": double.parse(weight),
              "reg_date":
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
              "pre_weight": double.parse(preWeight),
              "o2_value": double.parse(o2Value),
              "pulse": double.parse(pulse),
              "pulse_one": double.parse(pulseOne),
              "pulse_two": double.parse(pulseTwo),
              "temp": double.parse(temp),
              "final_ktv": double.parse(finalKtv),
              "ad_pulse": adPulse,
              "appointment_id": appointmentId
            }));
    print('qwe ${response.body}');
    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (jsonData['id'] != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editForm(
      int id,
      String dryWeight,
      String postWeight,
      String weightDifference,
      String totalUfGoal,
      String finalKtv,
      List distress) async {
    final response = await http.put(
        Uri.parse('http://medvic.mn/api/medical.appointment/$id'),
        headers: {
          'Access-token': Globals.getRegister(),
        },
        body: jsonEncode({
          "dry_weight": dryWeight,
          "post_weight": postWeight,
          "weight_difference": weightDifference,
          "total_uf_goal": totalUfGoal,
          "final_ktv": finalKtv,
          "distress": distress
        }));
    print('qwe ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
