import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper_example/page/image_to_text_page.dart';
import 'package:image_cropper_example/page/textData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_cropper_example/page/login_screen.dart';
import 'package:image_cropper_example/page/registration_screen.dart';
import 'package:image_cropper_example/page/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'DownPen';

  @override
  Widget build(BuildContext context) => MaterialApp(
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ImageTotext.id: (context) => ImageTotext(
                isGallery: true,
              ),
          HomePage.id: (context) => HomePage(),
        },
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.orange.shade100,
          accentColor: Colors.red,
        ),
        home: LoginScreen(),
      );
}
