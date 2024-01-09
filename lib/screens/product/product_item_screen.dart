import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:flutter/material.dart';

class ProductItemScreen extends StatefulWidget {
  final String name;
  final String uom;
  final String barcode;
  final Widget image;
  final String defaultCode;
  final String type;
  final String volume;
  final String weight;
  const ProductItemScreen(
      {super.key,
      required this.name,
      required this.uom,
      required this.barcode,
      required this.image,
      required this.defaultCode,
      required this.type,
      required this.volume,
      required this.weight});

  @override
  State<ProductItemScreen> createState() => _ProductItemScreenState();
}

class _ProductItemScreenState extends State<ProductItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.image,
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              // width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.mainColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRow(
                      _buildRightText('Барааны нэр:'),
                      _buildRightText(widget.name),
                    ),
                    _buildRow(
                      _buildRightText('Бар код:'),
                      _buildRightText(
                          widget.barcode == 'null' ? 'Хоосон' : widget.barcode),
                    ),
                    _buildRow(
                      _buildRightText('Дотоод сурвалж:'),
                      _buildRightText(widget.defaultCode),
                    ),
                    _buildRow(
                      _buildRightText('Хэмжих нэгж:'),
                      _buildRightText(widget.uom),
                    ),
                    _buildRow(
                      _buildRightText('Ангилал:'),
                      _buildRightText(widget.type),
                    ),
                    _buildRow(
                      _buildRightText('Жин:'),
                      _buildRightText(widget.weight),
                    ),
                    _buildRow(
                      _buildRightText('Тоо:'),
                      _buildRightText(widget.volume),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildRow(Widget row1, Widget row2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: row1),
        Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: row2),
              ],
            ))
      ],
    );
  }

  Text _buildRightText(String text) => Text(
        text,
        style: TextStyles.white16,
      );
}
