// ignore_for_file: file_names
import 'appoint_detail.dart';

class AppointmentDetailListModel {
  final List<AppointmentDetail> appointmentList;

  AppointmentDetailListModel({required this.appointmentList});

  factory AppointmentDetailListModel.fromJson(List<dynamic> parsedJson) {
    List<AppointmentDetail> appointment;

    appointment = parsedJson
        .map((activity) => AppointmentDetail.fromJson(activity))
        .toList();

    return AppointmentDetailListModel(
      appointmentList: appointment,
    );
  }
}
