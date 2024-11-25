import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/preferences_helper.dart';
import 'package:vicles/remix_icon.dart';

class MyListingPage extends StatefulWidget {
  const MyListingPage({super.key});

  @override
  State<MyListingPage> createState() => _MyListingPageState();
}

class _MyListingPageState extends State<MyListingPage> {
  String? _retrievedUser;
  String? _user;
  String? _id;

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

  @override
  Widget build(BuildContext context) {
    _retrieveUser();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Goes Here',
                style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 20))
          ],
        ),
      ),
    );
  }
}
