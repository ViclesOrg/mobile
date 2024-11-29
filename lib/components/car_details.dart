import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';
import 'package:vicles/remix_icon.dart';

class CarDetails extends StatefulWidget {
  final dynamic _car;
  const CarDetails({super.key, dynamic car}) : _car = car;
  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  bool _isCarLoding = true;
  List<dynamic> _dates = [];
  @override
  void initState() {
    super.initState();
    loadCarAvailabilityDates(int.parse(widget._car['id']));
  }

  @override
  Widget build(BuildContext context) {
    return handleState(widget._car);
  }

  // The problem here is that This function somehoe not sending the id of the car to the api
  Future<dynamic> loadCarAvailabilityDates(int id) async {
    try {
      final dates = await ApiService.post("renters/rentalDates", {
        "id": id,
      });
      print("REQUEST SENT");
      if (dates != null && dates['error']['code'] == 0) {
        setState(() {
          _isCarLoding = false;
        });
        _dates = dates['dates'];
        print(dates);
        print(_dates);
      }
    } catch (e) {
      setState(() {
        _isCarLoding = false;
      });
    }
  }

  Widget handleState(dynamic car) {
    if (_isCarLoding) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 253, 111, 0),
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Image.network(
            car["cover"],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Keep the first row as it is
              Row(
                children: [
                  Text(
                    '${car["cbrand"]} ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${car["cmodel"]}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // Use GridView for the remaining rows
              GridView(
                shrinkWrap: true, // Important to avoid infinite height error
                physics:
                    NeverScrollableScrollPhysics(), // Prevent scrolling within the modal
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 4, // Adjust based on design
                ),
                children: [
                  Row(
                    children: [
                      RemixIcon(
                        icon: 0xEB0F,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${car["owner"]}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RemixIcon(
                        icon: 0xEF0A,
                        color: Colors.grey,
                      ),
                      Text(
                        locale: Locale('fr', 'FR'),
                        ' ${utf8.decode(car["city"].toString().codeUnits)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RemixIcon(
                        icon: 0xEF65,
                        color: Colors.grey,
                      ),
                      Text(
                        locale: Locale('fr', 'FR'),
                        ' ${car['price']} DH/Jours',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RemixIcon(
                        icon: 0xEEE0,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${car["trunksize"]} Litres',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RemixIcon(
                        icon: 0xF3EB,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${car["seats"]} Places',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RemixIcon(
                        icon: 0xF326,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${car["gear"]}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<dynamic> carDatils(BuildContext context, dynamic car) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true, // For a larger popup
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width, minHeight: 300),
      context: context,
      builder: (context) => CarDetails(
            car: car,
          ));
}
