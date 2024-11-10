import 'zovuir_model.dart';

class ZovuirListModel {
  final List<Zovuir> zovuirList;

  ZovuirListModel({required this.zovuirList});

  factory ZovuirListModel.fromJson(List<dynamic> parsedJson) {
    List<Zovuir> zovuir;

    zovuir = parsedJson.map((activity) => Zovuir.fromJson(activity)).toList();

    return ZovuirListModel(
      zovuirList: zovuir,
    );
  }
}
