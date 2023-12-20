import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondBlack,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              color: AppColors.secondBlack,
            ),
            child: Text(
              'Цэс',
              style: TextStyles.white22semibold,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.note,
              color: Colors.white,
            ),
            title: const Text(
              'Ирц харах',
              style: TextStyles.white22,
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.attendanceScreen);
            },
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.train,
          // color: Colors.white,
          //   ),
          //   title: const Text(
          //     'Тооллого',
          //     style: TextStyles.black19,
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(context, RoutesName.countScreen);
          //   },
          // ),
        ],
      ),
    );
  }
}
