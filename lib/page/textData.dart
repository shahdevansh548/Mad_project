import 'package:flutter/material.dart';
import 'package:image_cropper_example/page/text_editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedData extends StatefulWidget {
  @override
  _SavedDataState createState() => _SavedDataState();
}

var savedList = {};

class _SavedDataState extends State<SavedData> {
  List savedList1 = [];
  List keys = [];

  void getSavedMap() {}

  void getSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('saved_data');
    if (data != '' && data != null) {
      savedList = json.decode(data);
      keys = savedList.keys.toList();
      for (String key in keys) {
        savedList1.add(savedList[key]);
      }
      print(savedList1);
    } else {
      print("null returned");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: savedList.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TextEditor(
                                text: 'text2',
                                name: keys[index],
                                isSaved: true,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.document_scanner),
                    title: Text(
                      keys[index],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
