import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/models/inventory_line_entity.dart';
import 'package:erp_medvic_mobile/screens/count/count_item_screen.dart';
import 'package:erp_medvic_mobile/service/count_update_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QtyUpdateScreen extends StatefulWidget {
  final int id;
  final InventoryLineEntity? item;

  const QtyUpdateScreen({super.key, required this.item, required this.id});

  @override
  State<QtyUpdateScreen> createState() => _QtyUpdateScreenState();
}

class _QtyUpdateScreenState extends State<QtyUpdateScreen> {
  QuantityUpdateApiClient qtyUpdate = QuantityUpdateApiClient();
  TextEditingController qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item!.productId!.displayName.toString(),
              style: TextStyles.black16semibold,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: qtyController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Тоо ширхэг оруулах',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await qtyUpdate.qtyUpdate(
                    widget.item!.id, qtyController.text, context);

                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CountItemScreen(
                              id: widget.id,
                              locationName: '',
                            )));
              },
              child: const Text('Тоо засах'),
            )
          ],
        ),
      ),
    );
  }
}
