import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';
import 'package:vicles/preferences_helper.dart';

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
        _isLoading = false;
        _cars = cars['cars'];
      }
    } catch (e) {
      _isLoading = false;
    }
  }

  List<Widget> carsFactory(List<dynamic> cars) {
    List<Widget> widgets = [];
    for (var car in cars) {
      Card c = Card(
          elevation: 2,
          surfaceTintColor: Colors.white,
          color: Color.fromARGB(255, 255, 248, 242),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(car["cbrand"] + ' ' + car["cmodel"]),
          ));
      widgets.add(c);
      if (car != cars.last) {
        widgets.add(SizedBox(
          height: 10,
        ));
      }
    }
    return widgets;
  }

  List<Widget> handleLoading() {
    if (_isLoading) {
      return [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 253, 111, 0),
                  ),
                ),
              ),
            ]),
      ];
    } else if (_cars.isNotEmpty) {
      return carsFactory(_cars);
    }
    return [
      Text('Aucun résultat',
          style: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              fontSize: 20))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(children: handleLoading()),
          ),
        ));
  }
}
