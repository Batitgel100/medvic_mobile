// To parse this JSON data, do
//
//     final attendanceListEntity = attendanceListEntityFromJson(jsonString);

import 'dart:convert';

AttendanceListEntity attendanceListEntityFromJson(String str) =>
    AttendanceListEntity.fromJson(json.decode(str));

String attendanceListEntityToJson(AttendanceListEntity data) =>
    json.encode(data.toJson());

class AttendanceListEntity {
  int id;
  DateTime? checkIn;
  DateTime? checkOut;
  int? employeeId;
  double? workedHours;

  AttendanceListEntity({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.employeeId,
    required this.workedHours,
  });

  factory AttendanceListEntity.fromJson(Map<String, dynamic> json) =>
      AttendanceListEntity(
        id: json["id"],
        checkIn: DateTime.parse(json["check_in"]),
        checkOut: DateTime.parse(json["check_out"]),
        employeeId: json["employee_id"],
        workedHours: json["worked_hours"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "check_in": checkIn!.toIso8601String(),
        "check_out": checkOut!.toIso8601String(),
        "employee_id": employeeId,
        "worked_hours": workedHours,
      };
}
