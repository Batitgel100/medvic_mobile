import 'package:erp_medvic_mobile/models/location_entity.dart';
import 'package:flutter/material.dart';

class LocationListWidget extends StatefulWidget {
  final List<LocationEntity> location;
  final Function(int) onLocationSelected;

  const LocationListWidget({
    Key? key,
    required this.location,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  late List<LocationEntity> filteredLocation;

  @override
  void initState() {
    super.initState();
    filteredLocation = List.from(widget.location);
  }

  void _searchLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLocation = List.from(widget.location);
      } else {
        filteredLocation = widget.location
            .where((item) =>
                (item.name?.toLowerCase() ?? '').contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            onChanged: _searchLocations,
            decoration: InputDecoration(
              labelText: 'Байршил хайх',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            thickness: 5,
            thumbVisibility: true,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: filteredLocation.length,
              itemBuilder: (BuildContext context, int index) {
                final item = filteredLocation[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: InkWell(
                    onTap: () {
                      widget.onLocationSelected(item.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue, // Change to your desired color
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.025),
                        child: Text(
                          item.name.toString(),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
