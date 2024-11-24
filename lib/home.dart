import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vicles/preferences_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome $_user and id is $_id',
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
