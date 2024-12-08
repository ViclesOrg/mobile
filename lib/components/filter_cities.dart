import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';

class FilterCities extends StatefulWidget {
  @override
  _FilterCitiesState createState() => _FilterCitiesState();
}

class _FilterCitiesState extends State<FilterCities> {
  List<dynamic> _cities = [];
  List<DropdownMenuItem<dynamic>> items = [];
  dynamic selectedValue;
  bool _citiesLoad = true;

  Future<dynamic> getCities() async {
    try {
      final cities = await ApiService.get("renters/cities", {});
      if (cities != null && cities['error']['code'] == 0) {
        _cities = cities['cities'];
        prepareItems();
      }
      setState(() {
        _citiesLoad = false;
      });
    } catch (e) {
      setState(() {
        _citiesLoad = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCities();
  }

  void prepareItems() {
    for (dynamic city in _cities) {
      items.add(DropdownMenuItem(
        value: city,
        child: Text(
          utf8.decode(city['name'].toString().codeUnits),
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_citiesLoad) {
      return Center(
        child: Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 253, 111, 0),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Choisir une Ville",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 20,
              height: 20,
            ),
            DropdownButton(
              dropdownColor: Colors.white,
              hint: Text(
                "Séléctionner une ville",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              value: selectedValue,
              items: items,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
            SizedBox(
              width: 40,
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (selectedValue == null) {
                      showCustomSnackBar(
                        context,
                        "Choisir une ville",
                        Colors.red,
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 253, 111, 0),
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    "Valider",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}

void showCustomSnackBar(BuildContext context, String message, Color color) {
  // Remove any existing overlays first to prevent stacking
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      // Position at the bottom of the screen
      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      // Center horizontally and add padding
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // Show the overlay and remove it after duration
  overlayState?.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry?.remove();
  });
}
