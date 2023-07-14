// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/apis/apisss.dart';
import 'package:todo/screens/Dashboard.dart';
import 'package:todo/screens/Signup.dart';
import 'package:todo/utils/text_font.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Api obj = Api();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var err = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    List<String> name = ["Enter Email", "Enter Password"];
    List<Icon> icons = [
      const Icon(Icons.email),
      const Icon(Icons.password),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Login', style: mText())),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            //autovalidateMode: AutovalidateMode.always,
            key: _formkey,
            child: Column(
              children: [
                Text(
                  err,
                  style: pText(),
                ),
                textField(name[0], icons[0], email),
                textField(name[1], icons[1], password),
                ElevatedButton(
                  onPressed: (() {
                    validater();
                  }),
                  child: loading == false
                      ? Text(
                          "Login",
                          style: mText(),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account!!",
                      style: nText(),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(const SignUp());
                        },
                        child: Text(
                          'SignUp',
                          style: nText(),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding textField(String name, Icon icons, TextEditingController data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: data,
          obscureText: name == "Enter Password" ? true : false,
          validator: (value) {
            if (name == "Enter Email") {
              return emailvalid(value!);
            } else {
              return passwordvalid(value!);
            }
          },
          decoration: InputDecoration(
            hintText: name,
            prefixIcon: icons,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          )),
    );
  }

  Future<void> validater() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      var statusvar1 = await obj.LoginPost(email.text, password.text);
      var statusvar = jsonDecode(statusvar1);
      if (statusvar["message"] == "Invalid Credential") {
        err = "";
        err = "Invalid Credential";
        loading = false;
        setState(() {});
      } else if (statusvar["message"] == "Welcome to dashboard") {
        loading = false;
        var pref = await SharedPreferences.getInstance();
        pref.setString("token", statusvar["token"]);
        Get.offAll(const Dashboard());
      } else if (statusvar["message"] == "Something went wrong") {
        err = "";
        loading = false;
        setState(() {
          err = "";
          err = "Something went wrong";
        });
      } else if (statusvar["message"] == "Server Error") {
        err = "";
        loading = false;
        setState(() {
          err = "";
          err = "Server error please try again later.";
        });
      } else if (statusvar["message"] == "Something Wrong") {
        err = "";
        loading = false;
        setState(() {
          err = "Something Wrong!!";
        });
      } else {
        loading = false;
        setState(() {
          err = "Something Wrong";
        });
      }
    }
  }

  String? emailvalid(String value) {
    if (value.isEmpty) {
      return "Email required";
    }
    return null;
  }

  String? passwordvalid(String value) {
    if (value.isEmpty) {
      return "Password required";
    }
    return null;
  }
}
