// ignore_for_file: must_be_immutable, unrelated_type_equality_checks

import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/models/zovuir_model.dart';
import 'package:erp_medvic_mobile/screens/appointment/appointmendt_create_screen.dart';
import 'package:erp_medvic_mobile/service/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AppointmentDetailScreen extends StatefulWidget {
  int id;
  List<DropdownItem<Zovuir>> list;
  AppointmentDetailScreen({super.key, required this.id, required this.list});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  TextEditingController dryWeightController = TextEditingController();
  TextEditingController postWeightController = TextEditingController();
  TextEditingController totalUfGoalController = TextEditingController();
  TextEditingController finalKtvController = TextEditingController();
  double weightDifference = 0.00;
  String lastName = '';
  String firstName = '';
  final controller = MultiSelectController<Zovuir>();
  @override
  void initState() {
    _refreshList();
    super.initState();
  }

  Future<void> _refreshList() async {
    await AppointmentService().appointmentFormDetail(widget.id).then((onValue) {
      setState(() {
        dryWeightController =
            TextEditingController(text: onValue.dryWeight.toString());
        postWeightController =
            TextEditingController(text: onValue.postWeight.toString());
        totalUfGoalController =
            TextEditingController(text: onValue.totalUfGoal.toString());
        finalKtvController =
            TextEditingController(text: onValue.finalKtv.toString());
        for (var element in onValue.distress) {
          controller.selectWhere((item) => item.value.id == element.id);
        }
        weightDifference = onValue.weightDifference;
        lastName = onValue.lastName;
        firstName = onValue.patientId.patient_id!.name!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.055,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final aaq = Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  AppointmendtCreateScreen(id: widget.id)));
                      aaq == 'null' ? setState(() {}) : setState(() {});
                    },
                    child: const Text('Үүсгэх')),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mainColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Үйлчилүүлэгчийн нэр',
                              style: TextStyles.white16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$lastName, $firstName',
                              style: TextStyles.white16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              controller: dryWeightController,
                              decoration: const InputDecoration(
                                  labelText: 'Хуурай жин',
                                  labelStyle: TextStyle(color: Colors.white)))),
                      Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              controller: postWeightController,
                              decoration: const InputDecoration(
                                  labelText: 'Эцсийн жин',
                                  labelStyle: TextStyle(color: Colors.white))))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          controller: totalUfGoalController,
                          decoration: const InputDecoration(
                              labelText: 'Зорилтот нийт УФ',
                              labelStyle: TextStyle(color: Colors.white))),
                    ),
                    Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            controller: finalKtvController,
                            decoration: const InputDecoration(
                                labelText: 'Эцсийн Kt/V',
                                labelStyle: TextStyle(color: Colors.white))))
                  ]),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width / 2.5,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.white))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Жингийн зөрүү',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            Text(weightDifference.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14))
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                      child: MultiDropdown<Zovuir>(
                        items: widget.list,
                        controller: controller,
                        searchEnabled: true,
                        chipDecoration: ChipDecoration(
                          deleteIcon: Icon(Icons.close,
                              size: 16,
                              color: Colors.white), // Optional delete icon
                          backgroundColor:
                              Colors.green, // Background color for the chip
                          padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8), // Padding inside each chip
                          border: Border.all(
                              color: Colors.grey, width: 1), // Optional border
                          labelStyle: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 14, // Font size
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              16)), // Rounded corners for the chip
                          spacing: 8,
                          runSpacing: 4,
                          wrap: true,
                        ),
                        fieldDecoration: FieldDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        dropdownDecoration: const DropdownDecoration(
                          marginTop: 20,
                          maxHeight: 400,
                          header: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        dropdownItemDecoration: DropdownItemDecoration(
                          selectedIcon:
                              const Icon(Icons.check_box, color: Colors.green),
                          disabledIcon:
                              Icon(Icons.lock, color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            List<Map<String, dynamic>> finalList = controller
                                .selectedItems
                                .map((item) => {
                                      'id': item.value.id
                                    }) // Extracting the id from Zovuir
                                .toList();
                            AppointmentService()
                                .editForm(
                                    widget.id,
                                    dryWeightController.text,
                                    postWeightController.text,
                                    dryWeightController.text,
                                    totalUfGoalController.text,
                                    finalKtvController.text,
                                    finalList)
                                .then((onValue) {
                              if (onValue) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Амжилттай')),
                                );
                                _refreshList();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Амжилтгүй')),
                                );
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.background,
                            ),
                            child: const Center(
                              child: Text(
                                'Хадгалах',
                                style: TextStyles.black16semibold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
          FutureBuilder(
              future: AppointmentService().appointmentDetail(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasData || snapshot.data != null) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.appointmentList.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {},
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildItem(
                                      'Жин',
                                      snapshot
                                          .data!.appointmentList[index].weight
                                          .toString()),
                                  _buildItem(
                                      'Урьдчилсан жин',
                                      snapshot.data!.appointmentList[index]
                                          .preWeight
                                          .toString()),
                                  _buildItem(
                                      'O2 утга',
                                      snapshot
                                          .data!.appointmentList[index].o2Value
                                          .toString()),
                                  _buildItem(
                                      'Импульс',
                                      snapshot
                                          .data!.appointmentList[index].pulse
                                          .toString()),
                                  _buildItem(
                                      'Импульсийн нэг',
                                      snapshot
                                          .data!.appointmentList[index].pulseOne
                                          .toString()),
                                  _buildItem(
                                      'Импульсийн хоёр',
                                      snapshot
                                          .data!.appointmentList[index].pulseTwo
                                          .toString()),
                                  _buildItem(
                                      'Температур',
                                      snapshot.data!.appointmentList[index].temp
                                          .toString()),
                                  _buildItem(
                                      'ad_pulse',
                                      snapshot.data!.appointmentList[index]
                                                  .adPulse ==
                                              'ad_pulse_pre'
                                          ? ' Диализийн өмнөх'
                                          : snapshot
                                                      .data!
                                                      .appointmentList[index]
                                                      .adPulse ==
                                                  'lad_pulse_one'
                                              ? 'АД/пульс 1 цаг'
                                              : snapshot
                                                          .data!
                                                          .appointmentList[
                                                              index]
                                                          .adPulse ==
                                                      'ad_pulse_nwo'
                                                  ? 'АД/пульс 2 цаг'
                                                  : snapshot
                                                              .data!
                                                              .appointmentList[
                                                                  index]
                                                              .adPulse ==
                                                          'ad_pulse_three'
                                                      ? 'АД/пульс 3 цаг'
                                                      : snapshot
                                                                  .data!
                                                                  .appointmentList[
                                                                      index]
                                                                  .adPulse ==
                                                              'ad_pulse_four'
                                                          ? 'АДИпульс 4 цаг'
                                                          : snapshot
                                                                      .data!
                                                                      .appointmentList[
                                                                          index]
                                                                      .adPulse ==
                                                                  'lad_pulse_fve'
                                                              ? 'АД/пульс 5 цаг'
                                                              : 'Диализийн дараах'
                                                                  .toString()),

                                  _buildItem(
                                    'бүртгэлийн_огноо',
                                    snapshot.data!.appointmentList[index]
                                                .regDate !=
                                            null
                                        ? DateFormat('yyyy/MM/dd').format(
                                            snapshot
                                                .data!
                                                .appointmentList[index]
                                                .regDate!)
                                        : "Хоосон байна",
                                  ),
                                  // _buildItem('Огноо', item.date ?? 'Хоосон'),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                  // } else if (snapshot.data == null) {
                  //   return const Center(
                  //     child: Text('Хоосон байна'),
                  //   );
                } else {
                  return const Center(
                    child: Text('холболтод асуудал гарлаа'),
                  );
                }
              }),
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
}
