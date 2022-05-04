import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_example/utils.dart';
import 'package:image_cropper_example/page/text_editor.dart';

class ImageTotext extends StatefulWidget {
  static String id = '/image_to_text';
  final bool isGallery;

  const ImageTotext({
    required this.isGallery,
  });

  @override
  _ImageTotextState createState() => _ImageTotextState();
}

class _ImageTotextState extends State<ImageTotext> {
  bool _converting = false;
  List<File> imageFiles = [];
  final textDetector = GoogleMlKit.vision.textDetector();
  var text2 =
      'Import images from gallery\n\nOR\n\nDirectly capture the images from Camera ';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            text2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: onClickedButton,
          heroTag: null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );

  Future onClickedButton() async {
    final file = await Utils.pickMedia(
      isGallery: widget.isGallery,
      cropImage: cropCustomImage,
    );

    if (file == null) return;
    setState(() {
      _converting = true;
    });
    final inputImage = InputImage.fromFile(file);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    for (TextBlock block in recognisedText.blocks) {
      final Rect rect = block.rect;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TextEditor(text: text)));
    textDetector.close();
    setState(() {
      _converting = true;
    });
  }

  static Future<File?> cropCustomImage(File imageFile) async =>
      await ImageCropper().cropImage(
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        sourcePath: imageFile.path,
        androidUiSettings: androidUiSettings(),
        iosUiSettings: iosUiSettings(),
      );

  static IOSUiSettings iosUiSettings() => IOSUiSettings(
        aspectRatioLockEnabled: false,
      );

  static AndroidUiSettings androidUiSettings() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      );
}
