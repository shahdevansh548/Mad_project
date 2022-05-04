import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper_example/constants.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// ignore: must_be_immutable
class TextEditor extends StatefulWidget {
  static String id = '/text_editor';

  String text;
  String name;
  bool isSaved;
  TextEditor({required this.text, this.name = '', this.isSaved = false});
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextEditor> {
  QuillController _controller = QuillController.basic();
  late String fileName;
  SaveExceptions isNotSaved = SaveExceptions.YOU_CAN_SAVE;
  var savedList = {};
  Future<SaveExceptions> getSavedData(
      String name, String convertedTextJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String key in savedList.keys.toList()) {
      if (key == name) {
        return SaveExceptions.FILE_ALREADY_EXISTS;
      }
    }
    savedList[name] = convertedTextJson;
    await prefs.setString('saved_data', json.encode(savedList));
    print(savedList);
    return SaveExceptions.YOU_CAN_SAVE;
  }

  void getSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('saved_data') ?? '';
    if (data != '' && data != null) {
      savedList = json.decode(data);
    } else {
      print("null returned");
    }
    initializeScreenWithScannedText();
    setState(() {});
  }

  void initializeScreenWithScannedText() {
    if (!widget.isSaved) {
      _controller = QuillController(
          document: Document.fromJson([
            {"insert": "${widget.text}\n"}
          ]),
          selection: TextSelection.collapsed(offset: 0));
    } else {
      _controller = QuillController(
          document: Document.fromJson(jsonDecode(savedList[widget.name])),
          selection: TextSelection.collapsed(offset: 0));
    }
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.text);
    getSaved();
  }

  final FlutterTts flutterTts = FlutterTts();
  Future<void> _speak() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(_controller.document.toPlainText());
    print(await flutterTts.getVoices);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          width: 75.0,
          height: 75.0,
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.hearing,
              size: 40.0,
              color: Colors.white,
            ),
            onPressed: _speak,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Down',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueAccent,
                  ),
                ),
                TextSpan(
                  text: 'Pen',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Add Your file Name',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextField(
                            onChanged: (inputName) {
                              setState(() {
                                fileName = inputName;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Container(
                            color: Colors.blueAccent,
                            child: TextButton(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                ),
                              ),
                              onPressed: () async {
                                var json = jsonEncode(
                                    _controller.document.toDelta().toJson());
                                print(json);
                                var status = await getSavedData(fileName, json);
                                setState(() {
                                  print(status);
                                  isNotSaved = status;
                                });
                                if (isNotSaved ==
                                    SaveExceptions.FILE_ALREADY_EXISTS) {
                                  print("Document Not Saved\n");
                                  WarningAlertBox(
                                      context: context,
                                      title: 'FILE ALREADY EXISTS',
                                      messageText:
                                          'File with entered name Already exists..... Please try another name ',
                                      buttonColor: Colors.red,
                                      titleTextColor: Colors.red,
                                      buttonTextColor: Colors.black,
                                      messageTextColor: Colors.black);
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.arrow_right_alt,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: QuillToolbar.basic(controller: _controller),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.lightBlueAccent,
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                    ),
                    child: QuillEditor.basic(
                      controller: _controller,
                      readOnly: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
