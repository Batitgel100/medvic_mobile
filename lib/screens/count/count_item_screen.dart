import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/models/inventory_line_entity.dart';
import 'package:erp_medvic_mobile/models/inventory_list.entity.dart';
import 'package:erp_medvic_mobile/models/prod_lot_entity.dart';
import 'package:erp_medvic_mobile/screens/count/add_inventory_line_dialog.dart';
import 'package:erp_medvic_mobile/screens/count/qty_update_screen.dart';
import 'package:erp_medvic_mobile/service/count_update_repo.dart';
import 'package:erp_medvic_mobile/service/create_inventory_line_repo.dart';
import 'package:erp_medvic_mobile/service/inventory_line_repo.dart';
import 'package:erp_medvic_mobile/service/inventorylist_api.dart';
import 'package:erp_medvic_mobile/service/prod_lot_repo.dart';
import 'package:erp_medvic_mobile/service/toollogo_ehluuleh_repo.dart';
import 'package:erp_medvic_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../constant/constant.dart';

class CountItemScreen extends StatefulWidget {
  final List<Map<String, int>>? locationIdList;
  final int? locationIdUltra;

  final int id;
  final String locationName;
  const CountItemScreen({
    super.key,
    required this.id,
    this.locationIdList,
    this.locationIdUltra,
    required this.locationName,
  });

  @override
  State<CountItemScreen> createState() => _CountItemScreenState();
}

class _CountItemScreenState extends State<CountItemScreen> {
  CreateInventoryLineApiClient createInventoryLine =
      CreateInventoryLineApiClient();
  List<InventoryLineEntity> productList = [];
  List<InventoryLineEntity> filteredList = [];
  String searchQuery = '';
  InventoryListApiClient inventoryListApiClient = InventoryListApiClient();
  QuantityUpdateApiClient qtyUpdate = QuantityUpdateApiClient();
  TsuvralUpdateApiClient tsuvralUpdate = TsuvralUpdateApiClient();
  InventoryListEntity? item;
  InventoryLineApiClient fetch = InventoryLineApiClient();
  ToollogoEhluulehApiClient start = ToollogoEhluulehApiClient();
  ToollogoBatlahApiClient confirm = ToollogoBatlahApiClient();
  TextEditingController qtyController = TextEditingController();

  bool filterByInventoryId(InventoryLineEntity inventoryId) {
    return inventoryId.inventoryId == widget.id;
  }

  int barcode = 0;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDatas();
  }

  Future<void> scanBarcode(BuildContext context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      print('barcode data: $barcodeScanRes');

      if (barcodeScanRes != '-1') {
        InventoryLineEntity? matchingProduct;

        for (var product in productList) {
          if (product.productId?.barcode == barcodeScanRes) {
            matchingProduct = product;
            break;
          }
        }

        if (mounted) {
          setState(() {
            if (matchingProduct != null) {
              print('Matching Product Found: ${matchingProduct.productId?.id}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => QtyUpdateScreen(
                            item: matchingProduct,
                            id: widget.id,
                          )));
            } else {
              print('No Matching Product Found');
              Utils.flushBarErrorMessage('Бараа олдсонгүй', context);
            }
          });
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'USER_CANCELLED') {
        print('Barcode scanning cancelled by user');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CountItemScreen(
                      id: widget.id,
                      locationIdList: widget.locationIdList,
                      locationName: widget.locationName,
                    )));
      } else {
        print('Failed to scan barcode: ${e.message}');
      }
    }
  }

  void _scan() async {
    await scanBarcode(context);
  }

  Future<void> fetchDatas() async {
    try {
      final data = await inventoryListApiClient.fetchData();
      final itemWithId = data.firstWhere(
        (item) => item.id == widget.id,
      );

      setState(() {
        item = itemWithId;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _refreshList() async {
    if (item != null) {
      List<InventoryLineEntity> updatedData = await fetch.fetchData();
      setState(() {
        productList = updatedData;
        filteredList = productList.where((item) {
          return item.productId!.displayName!
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> fetchData() async {
    try {
      List<InventoryLineEntity> data = await fetch.fetchData();
      setState(() {
        productList = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void toollogoEhluuleh() async {
    start.toollogoEhluuleh(widget.id);
  }

  void toollogoBatlah() async {
    confirm.toollogoBatlah(widget.id, context);
  }

  int locatiomId = 0;
  @override
  Widget build(BuildContext context) {
    String locationName = 'Хоосон';

    if (item != null &&
        item!.locationIds != null &&
        item!.locationIds!.isNotEmpty) {
      locationName = item!.locationIds![0].displayName.toString();
      locatiomId = item!.locationIds![0].id!;
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.055,
            ),
            _buildAppBar(context),
            _buildInformation(locationName),
            _build10SizedBox(),
            if (item!.state.toString() == 'confirm')
              _buildButtonRow(context)
            else
              const SizedBox(),
            _build10SizedBox(),
            _buildTextField(),
            _build10SizedBox(),
            if (isLoading) _listIndicator() else _buildList(),
          ],
        ),
      ),
    );
  }

  SizedBox _build10SizedBox() {
    return const SizedBox(
      height: 10,
    );
  }

  Expanded _listIndicator() {
    return const Expanded(
      flex: 2,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Expanded _buildList() {
    return Expanded(
      flex: 2,
      child: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: searchQuery.isEmpty
              ? productList.where(filterByInventoryId).length
              : filteredList.where(filterByInventoryId).length,
          itemBuilder: (BuildContext context, int index) {
            final item = searchQuery.isEmpty
                ? productList.where(filterByInventoryId).elementAt(index)
                : filteredList.where(filterByInventoryId).elementAt(index);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _line(),
                    _build('Бараа', item.productId!.displayName ?? 'Хоосон'),
                    _build('Гарт байгаа', item.theoreticalQty.toString()),
                    _build2(
                      'Тоолсон',
                      item.productQty.toString(),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  _qtyDialog(context, item, () async {
                                    qtyUpdate.qtyUpdate(
                                        item.id, qtyController.text, context);
                                    Navigator.pop(context);
                                    isLoading = true;
                                    setState(() {});
                                    await fetchData();
                                  }));
                        },
                        child: const Text(
                          'Тоо засах',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ),
                    _build('байршил', item.locationId?.displayName ?? 'Хоосон'),
                    _build2(
                      'Цуврал',
                      item.prodLotId?.name ?? 'Хоосон',
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => ProdLotUpdateDialog(
                                    item: item,
                                    onTap: () async {
                                      isLoading = true;
                                      setState(() {});

                                      await fetchData();
                                    },
                                  ));
                        },
                        child: const Text(
                          'Цуврал засах',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AlertDialog _qtyDialog(
      BuildContext context, InventoryLineEntity item, VoidCallback ontap) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.27,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                Expanded(
                    flex: 6,
                    child: Text(item.productId!.displayName.toString())),
              ],
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
              onPressed: ontap,
              child: const Text('Тоо засах'),
            )
          ],
        ),
      ),
    );
  }

  Container _buildTextField() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondBlack, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              filteredList = productList.where((item) {
                // Your search logic here
                return item.productId!.displayName!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    item.locationId!.displayName!
                        .toLowerCase()
                        .contains(query.toLowerCase());
              }).toList();
            });
          },
          decoration: const InputDecoration.collapsed(hintText: 'Хайх'),
        ),
      ),
    );
  }

  Row _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          () {
            print(locatiomId);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Dialogo(
                          id: widget.id,
                          ontap: () async {
                            isLoading = true;

                            await Future.delayed(const Duration(seconds: 1));
                            await fetchData();

                            setState(() {});
                          },
                          locationId: widget.locationIdUltra != null &&
                                  widget.locationIdUltra != 0
                              ? widget.locationIdUltra ?? 0
                              : null,
                          locationName: widget.locationName,
                        )));
          },
          'Бараа нэмэх',
        ),
        _buildButton(
          () {
            _scan();
          },
          'Тоо ширхэг',
        ),
        _buildButton(
          () {},
          'Хайрцаг',
        ),
      ],
    );
  }

  Expanded _buildInformation(String locationName) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.mainColor,
        ),
        child: Column(
          children: [
            if (item != null) // Add this check
              _buildItem('Тооллогын нэр', item!.name.toString()),
            if (item != null) // Add this check
              _buildItem('Санхуугийн огноо', item!.date.toString()),
            if (item != null) // Add this check
              _buildItem('Компани', item!.companyId!.name.toString()),
            if (item != null) // Add this check
              _buildItem('Байрлалууд', locationName),
            if (item != null) // Add this check
              _buildState(),
          ],
        ),
      ),
    );
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, RoutesName.countScreen);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
        if (item != null && item!.state.toString() == 'confirm')
          ElevatedButton(
              onPressed: () async {
                toollogoBatlah();

                setState(() {});
                isLoading = true;
                await fetchData();
                await fetchDatas();
                setState(() {});
                _refreshList();
              },
              child: const Text('Тооллого батлах'))
        else if (item != null && item!.state.toString() == 'draft')
          ElevatedButton(
              onPressed: () async {
                toollogoEhluuleh();
                await fetchData();
                await fetchDatas();

                setState(() {});
                _refreshList();
              },
              child: const Text('Тооллого эхлүүлэх'))
        else
          const SizedBox()
      ],
    );
  }

  Padding _line() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 1.5,
        color: Colors.black,
      ),
    );
  }

  Expanded _buildState() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Төлөв',
                style: TextStyles.white16,
              ),
              if (item!.state == 'done')
                const Text(
                  'Батлагдсан',
                  style: TextStyles.white16,
                )
              else if (item!.state == 'draft')
                const Text(
                  'Ноорог',
                  style: TextStyles.white16,
                )
              else if (item!.state == 'confirm')
                const Text(
                  'Явагдаж буй',
                  style: TextStyles.white16,
                )
              else if (item!.state == 'cancel')
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

  InkWell _buildButton(VoidCallback ontap, String text) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.mainColor),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              text,
              style: TextStyles.white16,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildItem(String text, String data) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // width: MediaQuery.of(context).size.width * 0.27,
              child: Text(
                '$text:',
                style: TextStyles.white16semibold,
              ),
            ),
            Text(
              data,
              style: TextStyles.white16,
            ),
          ],
        ),
      ),
    );
  }

  Padding _build(
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                '$type:',
                style: TextStyles.black16semibold,
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyles.black16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _build2(
    String type,
    String name,
    Widget button,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                '$type:',
                style: TextStyles.black16semibold,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                name,
                style: TextStyles.black16,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(child: button),
            ),
          ],
        ),
      ),
    );
  }
}

class ProdLotUpdateDialog extends StatefulWidget {
  final Function onTap;
  const ProdLotUpdateDialog({
    super.key,
    required this.item,
    required this.onTap,
  });

  final InventoryLineEntity item;

  @override
  State<ProdLotUpdateDialog> createState() => _ProdLotUpdateDialogState();
}

class _ProdLotUpdateDialogState extends State<ProdLotUpdateDialog> {
  bool isLoadingProdLot = true;
  List<ProdLotEntity> prodlotList = [];
  List<ProdLotEntity> filteredProdlotList = [];
  ProdLotApiClient getProdLotList = ProdLotApiClient();
  TsuvralUpdateApiClient tsuvralUpdate = TsuvralUpdateApiClient();
  late int prodLotId = 0;
  TextEditingController tsuvralController = TextEditingController();
  bool isProdLotChosen = false;
  bool prodLotSearching = false;
  var prodLotName = '';

  @override
  void initState() {
    super.initState();
    fetchProdLotData();
  }

  Future<void> fetchProdLotData() async {
    final data = await getProdLotList.fetchData();
    setState(() {
      prodlotList = data;
      isLoadingProdLot = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: isProdLotChosen ? 150 : 400,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProdLotList(
              productId: widget.item.productId!.id as int,
              onProdLotSelected: (ProdLotEntity selectedProdLot) {
                prodLotId = selectedProdLot.id;
                isProdLotChosen = true;
                prodLotName = selectedProdLot.name.toString();

                setState(() {});
              },
            ),
            ElevatedButton(
              onPressed: () {
                tsuvralUpdate.tsuvralUpdate(
                    widget.item.id, prodLotId.toString(), context);
                widget.onTap();
                Navigator.pop(context);

                setState(() {});
              },
              child: const Text('data'),
            ),
          ],
        ),
      ),
    );
  }
}

class BarcodeArgs {
  final String data;

  BarcodeArgs(this.data);
}

class ProdLotList extends StatefulWidget {
  final int productId;
  final Function(ProdLotEntity) onProdLotSelected;

  const ProdLotList({
    Key? key,
    required this.productId,
    required this.onProdLotSelected,
  }) : super(key: key);

  @override
  _ProdLotListState createState() => _ProdLotListState();
}

class _ProdLotListState extends State<ProdLotList> {
  late Future<List<ProdLotEntity>> prodLotData;
  late TextEditingController searchController;
  ProdLotApiClient getProdLotList = ProdLotApiClient();
  late Future<List<ProdLotEntity>> filteredProdLots;
  bool isProdLotChosen = false;
  String lotName = '';
  @override
  void initState() {
    super.initState();
    prodLotData = getProdLotList.fetchData();
    searchController = TextEditingController();
    filteredProdLots = prodLotData; // Initialize filteredProdLots with all data
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Wrap with a Container
      height: isProdLotChosen ? 50 : 350, // Set a height constraint
      child: Column(
        children: [
          isProdLotChosen
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) {
                      _searchProdLots(query);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
          Expanded(
            child: isProdLotChosen
                ? Text(
                    lotName,
                    style: TextStyles.black16semibold,
                  )
                : _buildProdLotList(filteredProdLots),
          ),
        ],
      ),
    );
  }

  void _searchProdLots(String query) {
    setState(() {
      filteredProdLots = prodLotData.then((data) {
        return data
            .where((prodLot) => prodLot.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  Widget _buildProdLotList(Future<List<ProdLotEntity>> data) {
    return FutureBuilder<List<ProdLotEntity>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('Хоосон байна.');
        } else {
          return Scrollbar(
            thumbVisibility: true,
            thickness: 5,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      isProdLotChosen = true;
                      setState(() {});
                      widget.onProdLotSelected(item);
                      lotName = item.name;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.mainColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          item.name.toString(),
                          style: TextStyles.white16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
