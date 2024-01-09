// ignore_for_file: use_build_context_synchronously

import 'package:erp_medvic_mobile/constant/constant.dart';
import 'package:erp_medvic_mobile/service/product_list_repo.dart';
import 'package:erp_medvic_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductSearchWidget extends StatefulWidget {
  final List<Map<String, int>> locationIdList;
  final Function(int, String) onProductSelected;
  final ProductListApiClientWithFilter getProductList;

  const ProductSearchWidget({
    Key? key,
    required this.locationIdList,
    required this.onProductSelected,
    required this.getProductList,
  }) : super(key: key);

  @override
  State<ProductSearchWidget> createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  bool isLoadingProduct = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data =
          await widget.getProductList.fetchData(widget.locationIdList, context);

      if (data.isNotEmpty) {
        setState(() {
          productList = data;
          filteredProductList = productList;
          isLoadingProduct = false;
        });
      } else {
        Utils.flushBarErrorMessage('Бараа байхгүй байна', context);
      }
    } catch (e) {
      Utils.flushBarErrorMessage('Бараа байхгүй байна', context);
    }
  }

  void _filterProducts(String query) {
    setState(
      () {
        filteredProductList = productList
            .where((product) => product.productId!.displayName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: searchController,
            onChanged: _filterProducts,
            decoration: InputDecoration(
              labelText: 'Бараа хайх',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        _productList(context, filteredProductList),
      ],
    );
  }

  Widget _productList(BuildContext context, List<Product> products) {
    return isLoadingProduct
        ? _buildIndicator()
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final item = products[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      int productId = item.productId!.id;
                      String productName = item.productId!.displayName;
                      widget.onProductSelected(productId, productName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.mainColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          item.productId!.displayName.toString(),
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

  Center _buildIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ProductSearchWidget2 extends StatefulWidget {
  final int locationIdList;
  final Function(int, String) onProductSelected;
  final ProdListApiClientWithSingleFilter getProductList;

  const ProductSearchWidget2({
    Key? key,
    required this.locationIdList,
    required this.onProductSelected,
    required this.getProductList,
  }) : super(key: key);

  @override
  State<ProductSearchWidget2> createState() => _ProductSearchWidget2();
}

class _ProductSearchWidget2 extends State<ProductSearchWidget2> {
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  bool isLoadingProduct = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data =
          await widget.getProductList.fetchData(widget.locationIdList, context);

      if (data.isNotEmpty) {
        setState(() {
          productList = data;
          filteredProductList = productList;
          isLoadingProduct = false;
        });
      } else {
        Utils.flushBarErrorMessage('Бараа байхгүй байна', context);
      }
    } catch (e) {
      Utils.flushBarErrorMessage('Бараа байхгүй байна', context);
    }
  }

  void _filterProducts(String query) {
    setState(
      () {
        filteredProductList = productList
            .where((product) => product.productId!.displayName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: searchController,
            onChanged: _filterProducts,
            decoration: InputDecoration(
              labelText: 'Бараа хайх',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        _productList(context, filteredProductList),
      ],
    );
  }

  Widget _productList(BuildContext context, List<Product> products) {
    return isLoadingProduct
        ? _buildIndicator()
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final item = products[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: InkWell(
                    onTap: () {
                      int productId = item.productId!.id;
                      String productName = item.productId!.displayName;
                      widget.onProductSelected(productId, productName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.mainColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          item.productId!.displayName.toString(),
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

  Center _buildIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
