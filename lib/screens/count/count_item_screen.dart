import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class CountItemScreen extends StatefulWidget {
  const CountItemScreen({super.key});

  @override
  State<CountItemScreen> createState() => _CountItemScreenState();
}

class _CountItemScreenState extends State<CountItemScreen> {
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.mainColor,
              ),
              child: Column(
                children: [
                  _buildItem(),
                  _buildItem(),
                  _buildItem(),
                  _buildItem(),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.secondBlack,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'all',
                            style: TextStyles.white16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.mainColor),
                    child: const Center(
                      child: Text(
                        'data',
                        style: TextStyles.white17,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.mainColor),
                    child: const Center(
                      child: Text(
                        'data',
                        style: TextStyles.white17,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.mainColor),
                    child: const Center(
                      child: Text(
                        'data',
                        style: TextStyles.white17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.secondBlack, width: 1)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'data:',
                        style: TextStyles.white17,
                      ),
                      Text(
                        'data:',
                        style: TextStyles.white17,
                      ),
                      Text(
                        'data:',
                        style: TextStyles.white17,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.secondBlack, width: 1)),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  decoration: InputDecoration.collapsed(hintText: 'Хайх'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildItem() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'name',
              style: TextStyles.white16,
            ),
            Text(
              'quantity',
              style: TextStyles.white16,
            ),
          ],
        ),
      ),
    );
  }
}
