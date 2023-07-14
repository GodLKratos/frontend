// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/apis/apisss.dart';
import 'package:todo/screens/Dashboard.dart';
import 'package:todo/screens/Login.dart';
import 'package:todo/utils/text_font.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var err = "";
  bool loading = false;
  Api obj = Api();
  @override
  Widget build(BuildContext context) {
    List<String> label = ["Enter Name", "Enter Email", "Enter Password"];
    List<Icon> icons = [
      const Icon(Icons.person),
      const Icon(Icons.email),
      const Icon(Icons.password),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Sign Up', style: mText())),
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
                textField(
                  label[0],
                  icons[0],
                  name,
                ),
                textField(label[1], icons[1], email),
                textField(label[2], icons[2], password),
                ElevatedButton(
                  onPressed: (() {
                    validater();
                  }),
                  child: loading == false
                      ? Text(
                          "SignUp",
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
                      "Already have an account!!",
                      style: nText(),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(const Login());
                        },
                        child: Text(
                          'Login',
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

  Padding textField(String label, Icon icons, TextEditingController data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: data,
          obscureText: label == "Enter Password" ? true : false,
          validator: (value) {
            if (label == "Enter Name") {
              return namevalid(value!);
            } else if (label == "Enter Email") {
              return emailvalid(value!);
            } else {
              return passwordvalid(value!);
            }
          },
          decoration: InputDecoration(
            hintText: label,
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
      loading = true;
      setState(() {
        
      });
      var statusvar1 = await obj.SigUpPost(name.text, email.text, password.text);
      var statusvar = jsonDecode(statusvar1);
      if (statusvar["message"] == "Email Already exist") {
        err = "";
        err = "Email Already exist";
        loading=false;
        setState(() {});
      } else if (statusvar["message"] == "Welcome to dashboard") {
        loading = false;
        setState(() {
          
        });
        var pref  = await SharedPreferences.getInstance();
        pref.setString("token", statusvar["token"]);
        Get.offAll(const Dashboard());
      }
      else if (statusvar["message"] == "Something went wrong"||statusvar["message"] == "Server Error"||statusvar["message"] == "Something Wrong") {
        err = "";
        loading = false;
        setState(() {
          err = "Something wrong";
        });
      } 
    }
  }

  String? namevalid(String value) {
    if (value.isEmpty) {
      return "Name required";
    }
    return null;
  }

  String? emailvalid(String value) {
    if (value.isEmpty) {
      return "Email required";
    } else if (RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value)) {
      return null;
    }
    return "Invalid Email";
  }

  String? passwordvalid(String value) {
    if (value.isEmpty) {
      return "Password required";
    } else if (value.length < 6) {
      return 'password must be at least six characters';
    }
    return null;
  }
}
