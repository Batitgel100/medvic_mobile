import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/globals.dart';
import 'package:erp_medvic_mobile/models/employe_data_entity.dart';
import 'package:erp_medvic_mobile/service/company_name_repo.dart';
import 'package:erp_medvic_mobile/service/settings_repo.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _refreshData = false;
  Future<void> logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    print('*** хэрэглэгч гарлаа');
    Navigator.pushReplacementNamed(
      context,
      RoutesName.login,
    );
  }

  CompanyNameRepository getcompany = CompanyNameRepository();

  @override
  void initState() {
    super.initState();
    getcompany.getCompanyName();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshData = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _refreshData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<EmployeeDataEntity?>(
            future: EmployeDataApiClient().getEmployeeData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show a loading indicator while fetching data.
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Интернэт холболтоо шалгана уу!',
                    style: TextStyles.black17,
                  ),
                );
              } else if (snapshot.hasData) {
                final employee = snapshot.data!;

                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  employee.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  employee.jobTitle.toString(),
                                  style: TextStyles.black17semibold,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.38,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.mainColor),
                          child: Column(
                            children: [
                              _buildRow(
                                Globals.getCompany(),
                                // 'IVCO',
                                'Компани',
                                const Icon(Icons.home, size: 40),
                              ),
                              _buildRow(
                                employee.mobilePhone.toString(),
                                // '99999999',
                                'Утасны дугаар',
                                const Icon(Icons.phone, size: 40),
                              ),
                              _buildRow(
                                employee.workEmail.toString(),
                                // 'email@ivco.mn',
                                'e-мэйл',
                                const Icon(Icons.email, size: 40),
                              ),
                              _buildRow(
                                employee.workLocation.toString(),
                                'Хаяг',
                                const Icon(Icons.location_city, size: 40),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text('Name: ${employee.name}'),
                //     Text('Job Title: ${employee.jobTitle}'),
                //     Text('Mobile Phone: ${employee.mobilePhone}'),
                //     // Add more Text widgets for other employee information here
                //   ],
                // );
              } else {
                return const Text('No employee data available');
              }
            },
          ),
          const Spacer(),
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.10,
            child: InkWell(
              onTap: logout,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.mainColor,
                ),
                child: const Center(
                  child: Text(
                    'Гарах',
                    style: TextStyles.white17semibold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildRow(String defualtText, String dynamicText, Icon icon) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon,
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dynamicText,
                style: TextStyles.white17semibold,
              ),
              Text(
                defualtText,
                style: TextStyles.white16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
