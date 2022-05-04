import 'package:image_cropper_example/page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkError extends StatelessWidget {
  static String id = '/network_error';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/network_error.jpg'),
          SizedBox(height: 40.0),
          Container(
            color: Colors.blueAccent,
            child: TextButton(
              child: Text(
                'TRY AGAIN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () async {
                ConnectivityResult cr =
                    await Connectivity().checkConnectivity();
                if (cr == ConnectivityResult.none) {
                } else {
                  Navigator.pushNamed(context, LoginScreen.id, arguments: true);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
