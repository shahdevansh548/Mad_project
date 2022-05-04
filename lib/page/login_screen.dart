import 'package:image_cropper_example/components/rounded_button.dart';
import 'package:image_cropper_example/page/network_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper_example/components/text_input_with_icon.dart';
import 'package:image_cropper_example/components/label_text.dart';
import 'package:image_cropper_example/page/registration_screen.dart';
import 'package:image_cropper_example/page/image_to_text_page.dart';
import 'package:image_cropper_example/brains/login_brain.dart';
import 'package:image_cropper_example/components/constants.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_cropper_example/components/text_input.dart';
import 'package:image_cropper_example/page/home_page.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';
  bool connected;

  LoginScreen({this.connected = false});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email = '', password = '';
  bool _submitting = false;
  bool _showPassword = true;
  Map<String, dynamic> log = {};

  void checkConnectivity() async {
    ConnectivityResult cr = await Connectivity().checkConnectivity();
    if (cr == ConnectivityResult.none) {
      setState(() {
        widget.connected = false;
      });
    } else {
      setState(() {
        widget.connected = true;
      });
    }
  }

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.connected) {
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
                  checkConnectivity();
                },
              ),
            ),
          ],
        ),
      );
    }
    return ModalProgressHUD(
      inAsyncCall: _submitting,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg_image_exam.jpg'),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                  child: CircleAvatar(
                    radius: 70.0,
                    child: Center(
                      child: Image.asset('images/exam.png'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, right: 30.0, left: 30.0),
                  child: Column(
                    children: [
                      TextInputWithIcon(
                        onChanged: (inputEmail) {
                          email = inputEmail;
                        },
                        icon: Icons.account_circle,
                        hint: 'E-mail Address',
                      ),
                      SizedBox(height: 25.0),
                      TextInputWithIcon(
                        suffixIcon: Icons.remove_red_eye_outlined,
                        onTapForSuffixIcon: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        ObscureText: _showPassword,
                        onChanged: (inputPassword) {
                          password = inputPassword;
                        },
                        icon: Icons.lock_outlined,
                        hint: 'Password',
                      ),
                      SizedBox(height: 40.0),
                      RoundedButton(
                        buttonTitle: "Sign In",
                        onPressed: () async {
                          setState(() {
                            _submitting = true;
                          });
                          late int error = 1;
                          late String warningMessage = '';
                          late String warningTitle = '';
                          if (email.isNotEmpty && password.isNotEmpty) {
                            Login_Brain lb =
                                Login_Brain(email: email, password: password);
                            log = await lb.doLogin();
                            print(log);
                            print(log['auth_exception'].toString());
                            if (log['auth_exception'].toString() ==
                                Auth_Exceptions.LOGIN_SUCCESSFULL.toString()) {
                              error = 0;
                              Future.delayed(
                                  Duration.zero,
                                  () => SuccessAlertBox(
                                        context: context,
                                        title: "LOGIN SUCCESSFULL",
                                        messageText:
                                            "You have successfully logged in",
                                        buttonColor: Colors.blueAccent,
                                        titleTextColor: Colors.blueAccent,
                                      ));
                              Navigator.pushNamed(context, HomePage.id,
                                  arguments: log);
                            } else if (log['auth_exception'].toString() ==
                                Auth_Exceptions.ACCOUNT_NOT_FOUND.toString()) {
                              warningMessage =
                                  "Account Related with the entered Email Not Found";
                              warningTitle = "ACCOUNT NOT FOUND";
                            } else if (log['auth_exception'].toString() ==
                                Auth_Exceptions.EMAIL_NOT_VERIFIED.toString()) {
                              warningMessage =
                                  "You have not verified your email,Please verify it and then try to login";
                              warningTitle = "EMAIL ID NOT VERIFIED";
                            } else if (log['auth_exception'].toString() ==
                                Auth_Exceptions.INVALID_PASSWORD.toString()) {
                              warningMessage =
                                  "Your password does not match with your email ID";
                              warningTitle = "INVALID PASSWORD";
                            } else if (log['auth_exception'].toString() ==
                                Auth_Exceptions.ACCOUNT_NOT_FOUND.toString()) {
                              warningMessage =
                                  "The details you entered doesn't match with any account";
                              warningTitle = "ACCOUNT NOT FOUND";
                            }
                          } else {
                            warningMessage = "Please Enter Your Details";
                            warningTitle = "INVALID DETAILS";
                          }
                          if (error == 1) {
                            WarningAlertBox(
                              context: context,
                              title: warningTitle,
                              messageText: warningMessage,
                              titleTextColor: Colors.blueAccent,
                              buttonColor: Colors.blueAccent,
                            );
                          }
                          setState(() {
                            _submitting = false;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 40.0, top: 20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "FORGOT PASSWORD",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        "Confirm your email and we will send the instruction",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.0,
                                      ),
                                      LabelText(label: "EMAIL"),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: TextInput(
                                          hint: "Enter your Email",
                                          onChanged: (inputEmail) {
                                            email = inputEmail;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      RoundedButton(
                                          buttonTitle: 'RESET PASSWORD',
                                          onPressed: () async {
                                            setState(() {
                                              _submitting = true;
                                            });
                                            Login_Brain lb = Login_Brain();
                                            var reset_exception =
                                                await lb.resetPassword(email);
                                            if (reset_exception.toString() ==
                                                Auth_Exceptions.RESET_LINK_SENT
                                                    .toString()) {
                                              WarningAlertBox(
                                                context: context,
                                                title: "RESET LINK SENT",
                                                messageText:
                                                    "Password reset link is sent successfully to your entered email",
                                                titleTextColor:
                                                    Colors.blueAccent,
                                                buttonColor: Colors.blueAccent,
                                              );
                                            } else if (reset_exception
                                                    .toString() ==
                                                Auth_Exceptions.INVALID_EMAIL
                                                    .toString()) {
                                              WarningAlertBox(
                                                context: context,
                                                title: "INVALID EMAIL",
                                                messageText:
                                                    "Email ID entered is not correct",
                                                titleTextColor:
                                                    Colors.blueAccent,
                                                buttonColor: Colors.blueAccent,
                                              );
                                            } else if (reset_exception
                                                    .toString() ==
                                                Auth_Exceptions
                                                    .ACCOUNT_NOT_FOUND
                                                    .toString()) {
                                              WarningAlertBox(
                                                context: context,
                                                title: "ACCOUNT NOT FOUND",
                                                messageText:
                                                    "No account found with the entered EMAIL",
                                                titleTextColor:
                                                    Colors.blueAccent,
                                                buttonColor: Colors.blueAccent,
                                              );
                                            }
                                            setState(() {
                                              _submitting = false;
                                            });
                                          }),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Forgot Password",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              radius: 9.0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(
                                  '?',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                radius: 8.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      LabelText(label: 'Sign In With'),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                _submitting = true;
                              });
                              print("I am Tapped");
                              Login_Brain lb = Login_Brain();
                              User? user = await lb.doLoginUsingGoogle();
                              print(user);
                              if (user != null) {
                                log['name'] = user.displayName;
                                log['email'] = user.email;
                                log['mobile'] = user.phoneNumber;
                                Future.delayed(
                                    Duration.zero,
                                    () => SuccessAlertBox(
                                          context: context,
                                          title: "LOGIN SUCCESSFULL",
                                          messageText:
                                              "You have successfully logged in",
                                          buttonColor: Colors.blueAccent,
                                          titleTextColor: Colors.blueAccent,
                                        ));
                                setState(() {
                                  _submitting = false;
                                });
                                Navigator.pushNamed(context, HomePage.id,
                                    arguments: log);
                              } else {
                                setState(() {
                                  _submitting = false;
                                });
                                WarningAlertBox(
                                  context: context,
                                  title: "LOGIN FAILED",
                                  messageText:
                                      "Some Error Occurred , so Can't Login...",
                                  titleTextColor: Colors.blueAccent,
                                  buttonColor: Colors.blueAccent,
                                );
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20.0,
                              child: Image.asset('images/google.png'),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: () {
                              WarningAlertBox(
                                context: context,
                                title: "LOGIN FAILED",
                                messageText:
                                    "Facebook Login Not enabled yet..... please try using google or email & password!!",
                                titleTextColor: Colors.blueAccent,
                                buttonColor: Colors.blueAccent,
                              );
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20.0,
                                child: Image.asset('images/facebook.png')),
                          ),
                          SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: () {
                              WarningAlertBox(
                                context: context,
                                title: "LOGIN FAILED",
                                messageText:
                                    "Twitter Login Not enabled yet..... please try using google or email & password!!",
                                titleTextColor: Colors.blueAccent,
                                buttonColor: Colors.blueAccent,
                              );
                            },
                            child: CircleAvatar(
                              radius: 20.0,
                              child: Image.asset('images/twitter.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
