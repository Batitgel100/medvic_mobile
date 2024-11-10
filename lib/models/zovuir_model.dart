class Zovuir {
  int id;
  String? name;

  Zovuir({
    required this.id,
    required this.name,
  });

  factory Zovuir.fromJson(Map<String, dynamic> json) => Zovuir(
        id: json["id"],
        name: json["name"] ?? 'Хоосон байна',
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
