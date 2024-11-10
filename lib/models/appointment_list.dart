// ignore_for_file: file_names

import 'appointment_model.dart';

class AppointmentListModel {
  final List<Appointment> appointmentList;

  AppointmentListModel({required this.appointmentList});

  factory AppointmentListModel.fromJson(List<dynamic> parsedJson) {
    List<Appointment> appointment;

    appointment =
        parsedJson.map((activity) => Appointment.fromJson(activity)).toList();

    return AppointmentListModel(
      appointmentList: appointment,
    );
  }
}
