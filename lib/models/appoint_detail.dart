class AppointmentDetail {
  int id;
  double weight;
  DateTime? regDate;
  double preWeight;
  double o2Value;
  double pulse;
  double pulseOne;
  double pulseTwo;
  double temp;
  double finalKtv;
  String adPulse;
  int appointmentId;

  AppointmentDetail({
    required this.id,
    required this.weight,
    required this.regDate,
    required this.preWeight,
    required this.o2Value,
    required this.pulse,
    required this.pulseOne,
    required this.pulseTwo,
    required this.temp,
    required this.finalKtv,
    required this.adPulse,
    required this.appointmentId,
  });

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) =>
      AppointmentDetail(
        id: json["id"],
        weight: json["weight"],
        regDate:
            json["reg_date"] == null ? null : DateTime.parse(json["reg_date"]),
        preWeight: json["pre_weight"],
        o2Value: json["o2_value"],
        pulse: json["pulse"],
        pulseOne: json["pulse_one"],
        pulseTwo: json["pulse_two"],
        temp: json["temp"],
        finalKtv: json["final_ktv"],
        adPulse: json["ad_pulse"],
        appointmentId: json["appointment_id"],
      );
}
