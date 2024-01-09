// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:erp_medvic_mobile/app_types.dart';
import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/models/location_entity.dart';
import 'package:erp_medvic_mobile/screens/count/location_search_dialog.dart';
import 'package:erp_medvic_mobile/screens/count/product_search_dialog.dart';
import 'package:erp_medvic_mobile/service/create_inventory_repo.dart';
import 'package:erp_medvic_mobile/service/location_list_repo.dart';
import 'package:erp_medvic_mobile/service/product_list_repo.dart';
import 'package:erp_medvic_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class Dialogoo extends StatefulWidget {
  final Function refreshListView;
  const Dialogoo({
    super.key,
    required this.refreshListView,
  });

  @override
  State<Dialogoo> createState() => _DialogooState();
}

class _DialogooState extends State<Dialogoo> {
  TextEditingController searchController = TextEditingController();
  TextEditingController locationSearchController = TextEditingController();
  ProductListApiClientWithFilter getProductList =
      ProductListApiClientWithFilter();
  CreateInventoryApiClient createInventoryLine = CreateInventoryApiClient();
  LocationListApiClient getLocationList = LocationListApiClient();
  TextEditingController inventoryNameController = TextEditingController();
  bool productSearching = false;
  bool locationSearching = false;
  bool isLoadingLocation = true;
  bool isLoadingProduct = true;
  bool isLocationChosen = false;
  bool choose = false;

  List<LocationEntity> locationList = [];
  List<LocationEntity> filteredLocation = [];
  List<Map<String, int>> productIds = [];
  List<Map<String, int>> locationIds = [];
  var productName = '';
  var locationName = '';
  late int productId = 0;
  late int locationId = 0;
  List<Product> selectedProductsList = [];
  @override
  void initState() {
    super.initState();
    fetchLocationData();
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
            child: ProductSearchWidget(
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
              getProductList: getProductList,
            ),
          ),
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
            _nameTitle(),
            _insetInventoryName(),
            _locTitle(),
            _searchLocation(),
            isLocationChosen ? _addedLocation() : const SizedBox(),
            _prodTitle(),
            _searchProduct(),
            _addedProduct(),
            const Spacer(),
            inventoryNameController.text == ''
                ? _unActiveButton(context)
                : locationId == 0
                    ? _unActiveButton(context)
                    : _createButton(context),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Center _createButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          createInventoryLine.create(
            inventoryNameController.text,
            productIds,
            locationIds,
          );
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, RoutesName.countScreen);
          widget.refreshListView();
          setState(() {});
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.white,
              boxShadow: const [BoxShadows.shadow3]),
          child: const Center(
            child: Text(
              'нэмэх',
              style: TextStyles.black16,
            ),
          ),
        ),
      ),
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
        print('***$locationIds');
        _showProductSearch();

        print('selected product length: ${selectedProductsList.length}');
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
                      choose = false;
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

  Padding _locTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 5),
      child: Text(
        'Байршил',
        style: TextStyles.black16,
      ),
    );
  }

  Padding _nameTitle() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 5.0, left: 5),
      child: Text(
        'Захиалгын нэр',
        style: TextStyles.black16,
      ),
    );
  }

  Container _insetInventoryName() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: inventoryNameController,
          decoration: const InputDecoration.collapsed(
              hintText: 'Захиалгын нэр оруулах'),
        ),
      ),
    );
  }

  Center _unActiveButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          if (inventoryNameController.text == '') {
            Utils.flushBarErrorMessage('Захиалгын нэрээ оруулна уу', context);
          } else if (locationIds.isEmpty) {
            Utils.flushBarErrorMessage('Байршил сонгоно уу', context);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.grey,
          ),
          child: const Center(
            child: Text(
              'нэмэх',
              style: TextStyles.black16,
            ),
          ),
        ),
      ),
    );
  }
}
