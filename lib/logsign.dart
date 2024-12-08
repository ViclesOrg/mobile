import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vicles/api_service.dart';
import 'package:vicles/fingerprint.dart';
import 'package:vicles/home.dart';
import 'package:vicles/preferences_helper.dart';
import 'package:vicles/remix_icon.dart';

class Logsign extends StatefulWidget {
  const Logsign({super.key});

  @override
  State<StatefulWidget> createState() => _LogsigbState();
}

class _LogsigbState extends State<Logsign> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  Future<void> _validateInputs() async {
    setState(() {
      // Validate email
      if (_emailController.text.trim().isEmpty) {
        _emailError = 'L\'email est requis';
      } else if (!isEmailValid(_emailController.text.trim())) {
        _emailError = 'Format d\'email invalide';
      } else {
        _emailError = null;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Le mot de passe est requis';
      } else {
        _passwordError = null;
      }
    });

    // If both validations pass
    // Replace the existing API call with this implementation
    if (_emailError == null && _passwordError == null) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 253, 111, 0),
                backgroundColor: Colors.white,
              ),
            );
          },
        );

        // Make the API call
        final response = await ApiService.post("renters/login", {
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
          "fingerprint": await DeviceFingerprint.generate()
        });

        // Hide loading indicator
        Navigator.of(context).pop();

        if (response != null && response['error']['code'] == 0) {
          // Handle successful login
          // You might want to store the token or user data here
          // For example:
          // await SharedPreferences.getInstance().then((prefs) {
          //   prefs.setString('token', response['token']);
          // });
          saveValue("user", jsonEncode(response));
          // Navigate to home screen or dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage(), // Replace with your home screen
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email ou mot de passe incorrect',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // Hide loading indicator if still showing
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().contains('HTTP Error:')
                    ? 'Email ou mot de passe incorrect'
                    : 'Une erreur est survenue. Veuillez réessayer.',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vicles',
                style: TextStyle(
                  color: Color.fromARGB(255, 253, 111, 0),
                  fontFamily: "Righteous",
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                            prefixIcon: const RemixIcon(icon: 0xEA83),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 253, 111, 0),
                              ),
                            ),
                            errorText: _emailError,
                            errorStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.red,
                            ),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            if (_emailError != null) {
                              setState(() {
                                _emailError = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                            prefixIcon: const RemixIcon(icon: 0xEED0),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 253, 111, 0),
                              ),
                            ),
                            errorText: _passwordError,
                            errorStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.red,
                            ),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                          obscureText: true,
                          onChanged: (_) {
                            if (_passwordError != null) {
                              setState(() {
                                _passwordError = null;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _validateInputs,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 253, 111, 0),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Connecter',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add your create account navigation logic here
                },
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Color.fromARGB(255, 253, 111, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'Version: 1.0.0',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
