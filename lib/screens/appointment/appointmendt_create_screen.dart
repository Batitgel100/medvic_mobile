// ignore_for_file: must_be_immutable

import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/service/appointment_service.dart';
import 'package:flutter/material.dart';

class AppointmendtCreateScreen extends StatefulWidget {
  int id;
  AppointmendtCreateScreen({super.key, required this.id});

  @override
  State<AppointmendtCreateScreen> createState() =>
      _AppointmendtCreateScreenState();
}

class _AppointmendtCreateScreenState extends State<AppointmendtCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();
  TextEditingController preWeightController = TextEditingController();
  TextEditingController o2ValueController = TextEditingController();
  TextEditingController pulseController = TextEditingController();
  TextEditingController pulseOneController = TextEditingController();
  TextEditingController pulseTwoController = TextEditingController();
  TextEditingController tempController = TextEditingController();
  TextEditingController finalKtvController = TextEditingController();
  final Map<String, String> _items = {
    'ad_pulse_pre': 'Диализийн өмнөх',
    'lad_pulse_one': 'АД/пульс 1 цаг',
    'ad_pulse_nwo': 'АД/пульс 2 цаг',
    'ad_pulse_three': 'АД/пульс 3 цаг',
    'ad_pulse_four': 'АД/пульс 4 цаг',
    'lad_pulse_fve': 'АД/пульс 5 цаг',
    'lad_pulse_after': 'Диализийн дараах'
  };
  String? _selectedValue;
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton(
                hint: const Text("АД/пульс"),
                value: _selectedItem,
                borderRadius: BorderRadius.circular(14),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue; // Update selected value
                  });
                },
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.abc, color: Colors.white),
                iconSize: 15,
                items: _items.entries.map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    onTap: () {
                      _selectedValue = entry.key;
                    },
                    child: Text(entry.value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 5),
            _buildTextField(weightController, 'жин'),
            _buildTextField(preWeightController, 'урьдчилсан жин'),
            _buildTextField(o2ValueController, 'O2 утга'),
            _buildTextField(pulseController, 'Импульс'),
            _buildTextField(pulseOneController, 'Импульсийн нэг'),
            _buildTextField(pulseTwoController, 'Импульсийн хоёр'),
            _buildTextField(tempController, 'Температур'),
            _buildTextField(finalKtvController, 'Эцсийн ktv'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    AppointmentService()
                        .daraltInsert(
                            weightController.text,
                            preWeightController.text,
                            o2ValueController.text,
                            pulseController.text,
                            pulseOneController.text,
                            pulseTwoController.text,
                            tempController.text,
                            finalKtvController.text,
                            _selectedValue!,
                            widget.id)
                        .then((value) {
                      if (value == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Амжилттай')),
                        );
                        Navigator.pop(context, 'asd');
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Амжилтгүй')),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.mainColor,
                      boxShadow: const [BoxShadows.shadow3]),
                  child: const Center(
                    child: Text(
                      'Илгээх',
                      style: TextStyles.white16semibold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Center(
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Хоосон байна';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: labelText,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
        ),
      );
}
