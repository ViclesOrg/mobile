import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';
import 'package:vicles/components/listing.dart';
import 'package:vicles/components/notifs.dart';
import 'package:vicles/components/profile.dart';
import 'package:vicles/preferences_helper.dart';
import 'package:vicles/remix_icon.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _retrievedUser;
  String? _user;
  String? _id;
  List<dynamic> _cities = [];
  bool _citiesLoad = true;
  int currentPageIndex = 0;

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
  }

  Future<dynamic> getCities() async {
    try {
      final cities = await ApiService.post("renters/cities", {});
      if (cities != null && cities['error']['code'] == 0) {
        _cities = cities['cities'];
      }
    } catch (e) {
      setState(() {
        _citiesLoad = false;
      });
    }
  }

  List<Widget> _conditionalRender() {
    if (currentPageIndex == 0) {
      return [
        Text("Vicles",
            style: TextStyle(
              color: Color.fromARGB(255, 253, 111, 0),
              fontFamily: "Righteous",
              fontSize: 36,
            )),
        Spacer(flex: 18),
        TextButton(
            onPressed: () {
              getCities();
              showDialog(
                  context: context,
                  builder: (context) {
                    if (_citiesLoad == true) {
                      Container(
                        color: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 253, 111, 0),
                          ),
                        ),
                      );
                    }
                    return AlertDialog(
                      surfaceTintColor: Colors.white,
                      backgroundColor: Colors.white,
                      title: Text(
                        "Filtre des villes",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    );
                  });
            },
            child: RemixIcon(icon: 0xEF0A, size: 24)),
        TextButton(
            onPressed: () {
              print("Filter");
            },
            child: RemixIcon(icon: 0xED27, size: 24))
      ];
    }
    return [
      Text(
        "Vicles",
        style: TextStyle(
          color: Color.fromARGB(255, 253, 111, 0),
          fontFamily: "Righteous",
          fontSize: 36,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Color.fromARGB(190, 0, 0, 0),
          elevation: 4,
          surfaceTintColor: Colors.white,
          title: Padding(
            padding: EdgeInsetsDirectional.all(4),
            child: Row(
              children: _conditionalRender(),
            ),
          )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey, // Border color
              width: 0.5, // Border width
            ),
          ),
        ),
        child: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              icon: RemixIcon(icon: 0xEE19),
              label: "Acceuil",
              selectedIcon: RemixIcon(
                icon: 0xEE19,
                color: Colors.white,
              ),
            ),
            NavigationDestination(
              icon: RemixIcon(icon: 0xEF94),
              label: "Notification",
              selectedIcon: RemixIcon(
                icon: 0xEF94,
                color: Colors.white,
              ),
            ),
            NavigationDestination(
              icon: RemixIcon(icon: 0xF25C),
              label: "Profile",
              selectedIcon: RemixIcon(
                icon: 0xF25C,
                color: Colors.white,
              ),
            )
          ],
          animationDuration: Duration(seconds: 2),
          selectedIndex: currentPageIndex,
          indicatorColor: Color.fromARGB(255, 253, 111, 0),
          backgroundColor: Colors.white,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
      ),
      body: <Widget>[
        MyListingPage(),
        MyNotificationsPage(),
        MyProfilePage()
      ][currentPageIndex],
    );
  }
}
