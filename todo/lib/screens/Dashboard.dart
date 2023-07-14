import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/apis/apisss.dart';
import 'package:todo/screens/Login.dart';
import 'package:todo/utils/text_font.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Api obj = Api();
  List? item;
  var id;

  @override
  void initState() {
    super.initState();
    returnUserID();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    TextEditingController data = TextEditingController();
    //fetchData(id);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Todo-List', style: mText())),
          actions: [
            TextButton(
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  pref.remove("token");
                  Get.offAll(const Login());
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tBox(width, data),
                  SizedBox(
                    width: width * 0.2,
                    height: height * 0.07,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            datahandle(data.text);
                          },
                          child: Text(
                            "Add",
                            style: mText(),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            item != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: item!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side:
                                  const BorderSide(width: 2, color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: Text(
                              "${index + 1} -",
                              style: nText(),
                            ),
                            title: Text(
                              "${item![index]["data"]}",
                              style: mText(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.deepOrangeAccent,
                              ),
                              onPressed: () {
                                del(item![index]["_id"]);
                              },
                            ),
                          ));
                    },
                  )
                : const Text("NO Data")
          ],
        ));
  }

  Flexible tBox(double width, TextEditingController data) {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
          controller: data,
          decoration: const InputDecoration(
            hintText: "Enter Task",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          )),
    ));
  }

  void datahandle(String data) async {
    if (data != "") {
      var statusvar1 = await obj.storeData(id, data);
      if (statusvar1 != null) {
        Get.snackbar(
          "Added",
          "Go for next one",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
        await fetchData(id);
      } else {
        Get.snackbar(
          "Error",
          "Try Again",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
      }
    }
  }

  fetchData(String id) async {
    var statusvar1 = await obj.getData(id);
    item = statusvar1['success'];
    setState(() {});
  }

  returnUserID() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    id = decodedToken["id"];
    await fetchData(id);
  }

  Future<void> del(String oid) async {
    var statusvar1 = await obj.delData(oid);
    if (statusvar1 == "Deleted") {
      Get.snackbar(
        "Deleted",
        "Enjoy",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
      );
      fetchData(id);
    } else {
      Get.snackbar(
        "Error",
        "Try Again",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
      );
    }
  }
}
