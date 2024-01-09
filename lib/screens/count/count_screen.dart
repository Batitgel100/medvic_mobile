import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/models/inventory_list.entity.dart';
import 'package:erp_medvic_mobile/screens/count/count_item_screen.dart';
import 'package:erp_medvic_mobile/screens/count/dialogoo.dart';
import 'package:erp_medvic_mobile/service/inventorylist_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountScreen extends StatefulWidget {
  const CountScreen({
    super.key,
  });

  @override
  State<CountScreen> createState() => _CountScreenState();
}

class _CountScreenState extends State<CountScreen> {
  InventoryListApiClient getInventoryList = InventoryListApiClient();
  final TextEditingController inventoryController = TextEditingController();
  List<InventoryListEntity> inventoryList = [];
  List<InventoryListEntity> filteredList = [];
  String searchQuery = '';
  bool isLoading = true;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    getInventoryList.fetchData().then((data) {
      if (mounted) {
        setState(() {
          inventoryList = data;
        });
      }
    });
  }

  Future<void> _refreshList() async {
    List<InventoryListEntity> updatedData = await getInventoryList.fetchData();
    setState(() {
      inventoryList = updatedData;
      filteredList = inventoryList.where((item) {
        return item.name!.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.055,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Dialogoo(
                                          refreshListView: _refreshList)))
                              .then((value) {
                            _refreshList();
                          });
                        },
                        child: const Text('Үүсгэх')),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildSearchLine(),
                _buildList(),
              ],
            )));
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
              filteredList = inventoryList.where((item) {
                // Your search logic here
                return item.name!.toLowerCase().contains(query.toLowerCase());
              }).toList();
            });
          },
        ),
      ),
    );
  }

  Expanded _buildList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 15),
          itemCount:
              searchQuery.isEmpty ? inventoryList.length : filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = searchQuery.isEmpty
                ? inventoryList[index]
                : filteredList[index];
            if (item.state != "draft" && item.state != "confirm") {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountItemScreen(
                        id: item.id,
                        locationIdUltra: item.locationIds != null &&
                                item.locationIds!.isNotEmpty
                            ? item.locationIds![0].id ?? 0
                            : 0,
                        locationName: item.locationIds != null &&
                                item.locationIds!.isNotEmpty
                            ? item.locationIds![0].displayName.toString()
                            : 'Default Location Name',
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.mainColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildItem('Тооллогын код', item.name ?? 'Хоосон'),
                      _buildItem(
                          'Санхуугийн огноо', item.accountingDate ?? 'Хоосон'),
                      _buildItem('Компани', item.companyId!.name ?? 'Хоосон'),
                      _buildItem(
                        'Байрлалууд',
                        (item.locationIds != null &&
                                item.locationIds!.isNotEmpty)
                            ? '${item.locationIds![0].displayName}'
                            : 'Хоосон',
                      ),
                      _buildItem('Огноо', item.date ?? 'Хоосон'),
                      _buildState(item),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding _buildState(InventoryListEntity item) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
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
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (item.state.toString() == 'done')
                const Text(
                  'Батлагдсан',
                  style: TextStyles.white16,
                )
              else if (item.state.toString() == 'draft')
                const Text(
                  'Ноорог',
                  style: TextStyles.white16,
                )
              else if (item.state.toString() == 'confirm')
                const Text(
                  'Явагдаж буй',
                  style: TextStyles.white16,
                )
              else if (item.state.toString() == 'cancel')
                const Text(
                  'Цуцлагдсан',
                  style: TextStyles.white16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
            ],
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: '0',
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: controller,
          ),
        ),
      ],
    );
  }
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
