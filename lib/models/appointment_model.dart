// class Appointment {
//   int id;
//   String name;
//   String lastName;
//   String? registerNumber;
//   DateTime appointmentDate;
//   DateTime appointmentEnd;
//   PatientId patientId;

//   Appointment({
//     required this.id,
//     required this.name,
//     required this.lastName,
//     required this.registerNumber,
//     required this.appointmentDate,
//     required this.appointmentEnd,
//     required this.patientId,
//   });

//   factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
//         id: json["id"],
//         name: json["name"],
//         lastName: json["last_name"],
//         registerNumber: json["register_number"],
//         appointmentDate: DateTime.parse(json["appointment_date"]),
//         appointmentEnd: DateTime.parse(json["appointment_end"]),
//         patientId: PatientId.fromJson(json["patient_id"]),
//       );
// }

// class PatientId {
//   int id;
//   String name;

//   PatientId({
//     required this.id,
//     required this.name,
//   });

//   factory PatientId.fromJson(Map<String, dynamic> json) => PatientId(
//         id: json["id"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//       };
// }

import 'zovuir_model.dart';

class Appointment {
  int id;
  String name;
  String lastName;
  String registerNumber;
  DateTime appointmentDate;
  DateTime appointmentEnd;
  String state;
  double dryWeight;
  double postWeight;
  double weightDifference;
  double totalUfGoal;
  double finalKtv;
  List<Zovuir> distress;
  PatientId patientId;

  Appointment({
    required this.id,
    required this.name,
    required this.lastName,
    required this.registerNumber,
    required this.appointmentDate,
    required this.appointmentEnd,
    required this.state,
    required this.dryWeight,
    required this.postWeight,
    required this.weightDifference,
    required this.totalUfGoal,
    required this.finalKtv,
    required this.distress,
    required this.patientId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        registerNumber: json["register_number"],
        appointmentDate: DateTime.parse(json["appointment_date"]),
        appointmentEnd: DateTime.parse(json["appointment_end"]),
        state: json["state"],
        dryWeight: json["dry_weight"]?.toDouble() ?? 0.00,
        postWeight: json["post_weight"]?.toDouble() ?? 0.00,
        weightDifference: json["weight_difference"]?.toDouble(),
        totalUfGoal: json["total_uf_goal"]?.toDouble() ?? 0.00,
        finalKtv: json["final_ktv"]?.toDouble() ?? 0.00,
        distress:
            List<Zovuir>.from(json["distress"].map((x) => Zovuir.fromJson(x))),
        patientId: PatientId.fromJson(json["patient_id"]),
      );
}

class PatientId {
  int id;
  String name;
  Zovuir? patient_id;

  PatientId({
    required this.id,
    required this.name,
    required this.patient_id,
  });

  factory PatientId.fromJson(Map<String, dynamic> json) => PatientId(
        id: json["id"],
        name: json["name"],
        patient_id: Zovuir.fromJson(json["patient_id"] ?? 'Хоосон байна'),
      );
}
