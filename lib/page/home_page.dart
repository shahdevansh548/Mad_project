import 'package:flutter/material.dart';
import 'package:image_cropper_example/main.dart';
import 'package:image_cropper_example/page/image_to_text_page.dart';
import 'package:image_cropper_example/page/textData.dart';
import 'package:image_cropper_example/brains/login_brain.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class HomePage extends StatefulWidget {
  static String id = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  bool isGallery = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            Row(
              children: [
                Text(
                  isGallery ? 'Gallery' : 'Camera',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isGallery,
                  onChanged: (value) => setState(() => isGallery = value),
                ),
                GestureDetector(
                  child: Icon(Icons.logout),
                  onTap: () async {
                    Login_Brain lb = Login_Brain();
                    var logout = await lb.doLogOutOfGoogle();
                    print(logout);
                    Future.delayed(
                        Duration.zero,
                        () => SuccessAlertBox(
                              context: context,
                              title: "LOGOUT SUCCESSFULL",
                              messageText: "You have successfully logged out",
                              buttonColor: Colors.blueAccent,
                              titleTextColor: Colors.blueAccent,
                            ));
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              child: TabBar(
                controller: controller,
                indicatorWeight: 1,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Text'),
                  Tab(text: 'Saved Documents'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  ImageTotext(isGallery: isGallery),
                  SavedData(),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: buildBottomBar(),
      );

  Widget buildBottomBar() {
    final style = TextStyle(color: Theme.of(context).accentColor);

    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('Cropper', style: style),
          label: 'Square',
        ),
        BottomNavigationBarItem(
          icon: Text('Cropper', style: style),
          label: 'Custom',
        ),
        BottomNavigationBarItem(
          icon: Text('Cropper', style: style),
          label: 'Predefined',
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }
}
