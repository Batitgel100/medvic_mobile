// ignore_for_file: avoid_print

import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/models/location_entity.dart';
import 'package:erp_medvic_mobile/models/prod_lot_entity.dart';
import 'package:erp_medvic_mobile/screens/count/location_search_dialog.dart';
import 'package:erp_medvic_mobile/screens/count/product_search_dialog.dart';
import 'package:erp_medvic_mobile/service/create_inventory_line_repo.dart';
import 'package:erp_medvic_mobile/service/location_list_repo.dart';
import 'package:erp_medvic_mobile/service/prod_lot_repo.dart';
import 'package:erp_medvic_mobile/service/product_list_repo.dart';
import 'package:flutter/material.dart';

class Dialogo extends StatefulWidget {
  final int? locationId;
  final VoidCallback ontap;
  final int id;
  final String locationName;
  const Dialogo({
    super.key,
    required this.id,
    required this.ontap,
    required this.locationId,
    required this.locationName,
  });

  @override
  State<Dialogo> createState() => _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  TextEditingController quantityController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  TextEditingController locationSearchController = TextEditingController();
  ProdListApiClientWithSingleFilter getProductList =
      ProdListApiClientWithSingleFilter();
  ProductListApiClientWithFilter list = ProductListApiClientWithFilter();
  LocationListApiClient getLocationList = LocationListApiClient();
  TextEditingController inventoryNameController = TextEditingController();
  ProdLotApiClient getProdLotList = ProdLotApiClient();

  CreateInventoryLineApiClient createInventoryLine =
      CreateInventoryLineApiClient();
  bool productSearching = false;
  bool locationSearching = false;
  bool isLoadingLocation = true;
  bool isLoadingProduct = true;
  bool isLocationChosen = false;
  bool choose = false;
  bool isLoadingProdLot = true;
  bool hasLoc = true;
  List<LocationEntity> locationList = [];
  List<LocationEntity> filteredLocation = [];
  List<Map<String, int>> productIds = [];
  List<Map<String, int>> locationIds = [];
  String quantityQuery = '';
  String prodLotquerys = '';

  var productName = '';
  var locationName = '';
  late int productId = 0;
  late int locationId = 0;
  List<Product> selectedProductsList = [];
  List<ProdLotEntity> prodlotList = [];
  List<ProdLotEntity> filteredProdlotList = [];

  late int prodLotId = 0;
  var prodLotName = '';
  bool isProdLotChosen = false;
  bool prodLotSearching = false;
  @override
  void initState() {
    super.initState();
    fetchProdLotData();
    fetchLocationData();
    if (widget.locationId == null && widget.locationId == null) {
      hasLoc = false;
      setState(() {});
    } else {
      hasLoc = true;
      setState(() {});
    }
    print('loc id: ${widget.locationId}');
  }

  Future<void> fetchProdLotData() async {
    final data = await getProdLotList.fetchData();
    setState(() {
      prodlotList = data;
      isLoadingProdLot = false;
    });
  }

  Future<void> fetchLocationData() async {
    try {
      final data = await getLocationList.fetchData();
      setState(() {
        locationList = data;
        isLoadingLocation = false;
      });
    } catch (error) {
      print('Error fetching location data: $error');
      isLoadingLocation = false;
    }
  }

  LocationEntity getLocationById(int id) {
    final matchingProducts =
        locationList.where((location) => location.id == id).toList();

    if (matchingProducts.isNotEmpty) {
      return matchingProducts.first;
    } else {
      return LocationEntity(
        id: -1,
        name: '',
        usage: 'internal',
      );
    }
  }

  void _showProdLotDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 400,
            child: SizedBox(
              width: double.maxFinite,
              child: ProdLotListWidget(
                productId: productId,
                onProdLotSelected: (ProdLotEntity selectedProdLot) {
                  prodLotId = selectedProdLot.id;
                  isProdLotChosen = true;
                  prodLotName = selectedProdLot.name.toString();
                  setState(() {});
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void addLocationId() {
    locationIds.add({"id": locationId});
  }

  void _showProductSearch() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              width: double.maxFinite,
              height: 600,
              child: hasLoc
                  ? ProductSearchWidget2(
                      locationIdList: widget.locationId!,
                      onProductSelected:
                          (int selectedProductId, String selectedProductName) {
                        productId = selectedProductId;
                        productName = selectedProductName;
                        choose = true;
                        setState(() {});

                        selectedProductsList.add(Product(
                            id: selectedProductId,
                            productId: ProductId(
                                id: selectedProductId,
                                displayName: selectedProductName)));

                        setState(() {});
                        Navigator.pop(context);
                      },
                      getProductList: getProductList,
                    )
                  : ProductSearchWidget(
                      locationIdList: locationIds,
                      onProductSelected:
                          (int selectedProductId, String selectedProductName) {
                        productId = selectedProductId;
                        productName = selectedProductName;

                        // Add the selected product to the list
                        selectedProductsList.add(Product(
                            id: selectedProductId,
                            productId: ProductId(
                                id: selectedProductId,
                                displayName: selectedProductName)));

                        setState(() {}); // Trigger a rebuild to update the UI
                        Navigator.pop(context);
                      },
                      getProductList: list,
                    )),
        );
      },
    );
  }

  void _showLocationSearchResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: LocationListWidget(
              location: locationList,
              onLocationSelected: (int locationId) {
                setState(() {
                  this.locationId = locationId;
                  addLocationId();

                  isLocationChosen = true;
                  locationName = locationList
                      .firstWhere((loc) => loc.id == locationId)
                      .name!;
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _locTitle(),
            hasLoc
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.locationName,
                      style: TextStyles.black16semibold,
                    ),
                  )
                : const SizedBox(),
            hasLoc
                ? const SizedBox()
                : isLocationChosen
                    ? const SizedBox()
                    : _searchLocation(),
            isLocationChosen ? _addedLocation() : const SizedBox(),
            _prodTitle(),
            choose ? const SizedBox() : _searchProduct(),
            _addedProduct(),
            _prodLotTitle(),
            isProdLotChosen ? _buildSelectedProdLot() : _buildProdLotButton(),
            _buildQuantityInsert(),
            const SizedBox(
              height: 20,
            ),
            _buildAddButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildProdLotButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ElevatedButton(
        onPressed: () {
          _showProdLotDialog();
        },
        child: const Text('Сонгох'),
      ),
    );
  }

  Column _buildSelectedProdLot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.blue)),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 8, child: Text(prodLotName)),
              Expanded(
                child: InkWell(
                  onTap: () {
                    isProdLotChosen = false;
                    prodLotId = 0;
                    setState(() {});
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildQuantityInsert() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Барааны тоо',
            style: TextStyles.black16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (query) {
                  quantityQuery = query;
                  setState(() {
                    productSearching = false;
                    locationSearching = false;
                  });
                },
                controller: quantityController,
                decoration: const InputDecoration.collapsed(
                    hintText: 'Барааны тоо оруулах'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ElevatedButton _searchLocation() {
    return ElevatedButton(
      onPressed: () {
        // _searchLocations();
        _showLocationSearchResults();
      },
      child: const Text('Сонгох'),
    );
  }

  _searchProduct() {
    return ElevatedButton(
      onPressed: () {
        _showProductSearch();
      },
      child: const Text('Сонгох'),
    );
  }

  Column _addedProduct() {
    return Column(
      children: selectedProductsList.map((product) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.blue)),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.productId!.displayName,
                  ),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      )),
                  onTap: () {
                    selectedProductsList.remove(product);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  InkWell _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        double quantity = double.tryParse(quantityController.text) ?? 0.0;

        createInventoryLine.create(productId, widget.locationId!, widget.id,
            quantity, prodLotId, 0, context);
        widget.ontap();
        Navigator.of(context).pop();
        setState(() {});
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: const [BoxShadows.shadow3]),
        child: const Center(
          child: Text('нэмэх'),
        ),
      ),
    );
  }

  Column _addedLocation() {
    return Column(
      children: locationIds.map((locationIdMap) {
        final locationId = locationIdMap["id"];
        final locationName =
            getLocationById(locationId!).name; // Replace with your actual logic

        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.blue)),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 8, child: Text(locationName.toString())),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      isLocationChosen = false;
                      locationIds.remove(locationIdMap);
                      setState(() {});
                      print(locationIds.length);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red),
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Padding _prodTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0, left: 5),
      child: Text(
        'Бараа',
        style: TextStyles.black16,
      ),
    );
  }

  Padding _prodLotTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0, left: 5),
      child: Text(
        'Цуврал',
        style: TextStyles.black16,
      ),
    );
  }

  Padding _locTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 5),
      child: Text(
        'Байршил',
        style: TextStyles.black16,
      ),
    );
  }
}

class ProdLotListWidget extends StatefulWidget {
  final int productId;
  final Function(ProdLotEntity) onProdLotSelected;

  const ProdLotListWidget({
    Key? key,
    required this.productId,
    required this.onProdLotSelected,
  }) : super(key: key);

  @override
  _ProdLotListWidgetState createState() => _ProdLotListWidgetState();
}

class _ProdLotListWidgetState extends State<ProdLotListWidget> {
  late Future<List<ProdLotEntity>> prodLotData;
  late TextEditingController searchController;
  ProdLotApiClient getProdLotList = ProdLotApiClient();
  late Future<List<ProdLotEntity>> filteredProdLots;

  @override
  void initState() {
    super.initState();
    prodLotData = getProdLotList.fetchData();
    searchController = TextEditingController();
    filteredProdLots = prodLotData; // Initialize filteredProdLots with all data
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
          child: _buildProdLotList(filteredProdLots),
        ),
      ],
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
          return const CircularProgressIndicator();
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
                      widget.onProdLotSelected(item);
                      Navigator.pop(context);
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
