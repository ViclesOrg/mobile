import 'package:flutter/material.dart';
import 'package:vicles/home.dart';
import 'package:vicles/preferences_helper.dart';
import 'logsign.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vicles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _retrievedUser;

  Future<void> _retrieveUser() async {
    String? token = await getValue("user");
    setState(() {
      _retrievedUser = token ?? "No token found!";
    });
  }

  @override
  void initState() {
    super.initState();
    // Navigate after delay
    _retrieveUser();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => (_retrievedUser == "No token found!"
                ? const Logsign()
                : const MyHomePage())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // or any background color you prefer
      body: Center(
        child: Text(
          "Vicles",
          style: TextStyle(
            color: Color.fromARGB(255, 253, 111, 0),
            fontFamily: "Righteous",
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
