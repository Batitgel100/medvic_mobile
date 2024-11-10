import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/models/appointment_list.dart';
import 'package:erp_medvic_mobile/models/appointment_model.dart';
import 'package:erp_medvic_mobile/models/zovuir_model.dart';
import 'package:erp_medvic_mobile/screens/appointment/appointment_detail_screen.dart';
import 'package:erp_medvic_mobile/service/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  AppointmentListModel? inventoryList;
  List<Appointment> filteredList = [];
  String searchQuery = '';
  List<DropdownItem<Zovuir>> dropdownItems = [];
  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    AppointmentListModel updatedData =
        await AppointmentService().appointmentList();
    setState(() {
      inventoryList = updatedData;
      filteredList = inventoryList!.appointmentList.where((item) {
        return item.lastName.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
    await AppointmentService().zovuir().then((onValue) {
      // for (var element in onValue.zovuirList) {
      //   dropdownItems.add(
      //     DropdownItem(
      //         label: element.name!,
      //         value: Zovuir(name: element.name, id: element.id)),
      //   );
      //   print('end urt irnee ${element.name}');
      // }
      // setState(() {});
      dropdownItems.clear(); // Clear old items if necessary
      for (var element in onValue.zovuirList) {
        if (element.name != null) {
          dropdownItems.add(DropdownItem(
            label: element.name!,
            value: Zovuir(name: element.name!, id: element.id),
          ));
          print('Added item: ${element.name}');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: _buildSearchLine(),
          ),
          Expanded(
              child: filteredList.isEmpty && dropdownItems.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AppointmentDetailScreen(
                                        id: filteredList[index].id,
                                        list: dropdownItems,
                                      ))),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.mainColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildItem('Эмчилгээний дугаар',
                                    filteredList[index].name),
                                _buildItem('Үйлчилүүлэгчийн нэр',
                                    '${filteredList[index].lastName}, ${filteredList[index].patientId.patient_id!.name}'),
                                _buildItem(
                                  'Эмчилгээ эхэлсэн',
                                  DateFormat('yyyy/MM/dd').format(
                                      filteredList[index].appointmentDate),
                                ),
                                _buildItem(
                                  'Эмчилгээ дууссан',
                                  DateFormat('yyyy/MM/dd').format(
                                      filteredList[index].appointmentEnd),
                                ),
                                // _buildItem('Огноо', item.date ?? 'Хоосон'),
                              ],
                            ),
                          ),
                        );
                      })),
        ],
      ),
    );
  }

  Padding _buildItem(
    String type,
    String name,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                type,
                style: TextStyles.white16,
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyles.white16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSearchLine() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondBlack, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          decoration: const InputDecoration.collapsed(hintText: 'Хайх'),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              filteredList = inventoryList!.appointmentList.where((item) {
                // Your search logic here
                return item.lastName
                    .toLowerCase()
                    .contains(query.toLowerCase());
              }).toList();
            });
          },
        ),
      ),
    );
  }
}
