import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/Dashboard.dart';
import 'package:todo/screens/Login.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  var pref  = await SharedPreferences.getInstance();
  runApp( MyApp(token: pref.getString("token"),));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  var token;
   MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
            .copyWith(secondary: Colors.red),
      ),
      debugShowCheckedModeBanner: false,
      home:token!=null?const Dashboard():const Login(),
    );
  }
}
