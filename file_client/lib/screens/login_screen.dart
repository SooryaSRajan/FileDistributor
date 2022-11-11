import 'dart:convert';

import 'package:file_client/screens/file_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map<String, String> customHeaders = {"content-type": "application/json"};

  _login(String password) async {
    var response = await http.post(getURI("/auth/login"),
        headers: customHeaders, body: jsonEncode({"password": password}));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login successful")));

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return FileScreen(
          token: json.decode(response.body)["token"],
        );
      }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.body)["message"])));
    }
  }

  final _formKey = GlobalKey<FormFieldState>();
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    TextFormField(
                      key: _formKey,
                      obscureText: true,
                      validator: (data) {
                        if (data == null) {
                          return "Please enter password";
                        } else if (data.isEmpty) {
                          return "Please enter password";
                        }
                      },
                      onChanged: (data) {
                        password = data;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Enter password",
                          filled: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login(password);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text("Unlock"),
                              ))),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
