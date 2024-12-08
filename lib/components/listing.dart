import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';
import 'package:vicles/components/car_details.dart';
import 'package:vicles/preferences_helper.dart';
import 'package:vicles/remix_icon.dart';

const String utf8Encoding = 'UTF-8';

class MyListingPage extends StatefulWidget {
  const MyListingPage({super.key});

  @override
  State<MyListingPage> createState() => _MyListingPageState();
}

class _MyListingPageState extends State<MyListingPage> {
  String? _retrievedUser;
  String? _user;
  String? _id;
  bool _isLoading = true;
  List<dynamic> _cars = [];

  Future<void> _retrieveUser() async {
    String? token = await getValue("user");
    setState(() {
      _retrievedUser = token ?? "No token found!";
      if (_retrievedUser != "No token found!") {
        _user = jsonDecode(_retrievedUser.toString())['user']['name'];
        _id = jsonDecode(_retrievedUser.toString())['user']['id'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveUser();
    getCarListing();
  }

  Future<void> getCarListing() async {
    try {
      final cars = await ApiService.post("renters/allCars", {});
      if (cars != null && cars['error']['code'] == 0) {
        setState(() {
          _isLoading = false;
        });
        _cars = cars['cars'];
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> carsFactory(List<dynamic> cars) {
    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 0, 16),
        child: Text(
          'Voitures disponibles',
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ];
    for (var car in cars) {
      Card card = Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: Colors.grey,
            width: .2,
          ),
        ),
        elevation: 3,
        child: InkWell(
          onTap: () {
            carDatils(context, car);
          },
          child: SizedBox(
            height: 100, // Match the image height
            child: Row(
              children: [
                // Image on the left
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  child: Image.network(
                    car["cover"],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                // Details on the right
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            )
                          ],
                        ),
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
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            RemixIcon(
                              icon: 0xEF65,
                              color: Colors.grey,
                            ),
                            Text(
                              ' ${car["price"]} DH/Jour',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            )
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
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      widgets.add(card);

      // Add spacing between cards
      if (car != cars.last) {
        widgets.add(const SizedBox(height: 10));
      }
    }
    return widgets;
  }

  Widget handleLoading() {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 253, 111, 0),
          ),
        ),
      );
    } else if (_cars.isNotEmpty) {
      return ListView(
        children: carsFactory(_cars),
      );
    }
    return Text('Aucun résultat',
        style: const TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 20));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: handleLoading(),
          ),
        ));
  }
}
