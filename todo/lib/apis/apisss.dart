import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  SigUpPost(String name, String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse("https://breakable-purse-tick.cyclic.app/reg"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body:
              jsonEncode({"name": name, "email": email, "password": password}));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return jsonEncode({
          "message": "Something went wrong",
        });
      }
    } catch (e) {
      return jsonEncode({
        "message": "Server Error",
      });
    }
  }

  LoginPost(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse("https://breakable-purse-tick.cyclic.app/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"email": email, "password": password}));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return jsonEncode({
          "message": "Something went wrong",
        });
      }
    } catch (e) {
      return jsonEncode({
        "message": "Server Error",
      });
    }
  }

  storeData(String userId, String data) async {
    try {
      final response = await http.post(
          Uri.parse("https://breakable-purse-tick.cyclic.app/data"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"userId": userId, "data": data}));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return jsonEncode({
          "message": "Something went wrong",
        });
      }
    } catch (e) {
      return jsonEncode({
        "message": "Something  wrong",
      });
    }
  }

  getData(String userId) async {
    try {
      final response = await http.post(
          Uri.parse("https://breakable-purse-tick.cyclic.app/getdata"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"userId": userId}));
        //  print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
    delData(String oid) async {
    try {
      final response = await http.post(
          Uri.parse("https://breakable-purse-tick.cyclic.app/del"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"_id": oid}));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
