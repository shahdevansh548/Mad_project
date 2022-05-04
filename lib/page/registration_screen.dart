import 'package:flutter/material.dart';
import 'package:image_cropper_example/components/text_input.dart';
import 'package:image_cropper_example/components/label_text.dart';
import 'package:image_cropper_example/components/rounded_button.dart';
import 'package:image_cropper_example/page/login_screen.dart';
import 'package:image_cropper_example/brains/registration_brain.dart';
import 'package:image_cropper_example/components/constants.dart'
    show Auth_Exceptions;
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String name, email, password, mobile;
  TextEditingController controller = TextEditingController();
  bool passwordStrong = false,
      mobileCorrect = false,
      emailCorrect = false,
      nameCorrect = false,
      _submitting = false;
  RegistrationBrain rb = RegistrationBrain();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _submitting,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF2269D5),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 40.0, left: 30.0, bottom: 30.0),
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.app_registration,
                      size: 50.0,
                    ),
                    radius: 50.0,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 30.0,
                  right: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      label: 'Basic Information',
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextInput(
                      hint: 'Full Name',
                      borderColor: !nameCorrect ? 0xFFFF0000 : 0xFF008000,
                      onChanged: (inputName) {
                        setState(() {
                          nameCorrect = rb.checkName(inputName);
                          print(nameCorrect);
                          if (nameCorrect) {
                            name = inputName;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextInput(
                      borderColor: !emailCorrect ? 0xFFFF0000 : 0xFF008000,
                      onChanged: (inputEmail) {
                        setState(() {
                          emailCorrect = rb.checkEmail(inputEmail);
                          print(emailCorrect);
                          if (emailCorrect) {
                            email = inputEmail;
                          }
                        });
                      },
                      hint: 'Email',
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    LabelText(label: "Private Information"),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextInput(
                      obscureText: true,
                      hint: 'Password',
                      borderColor: !passwordStrong ? 0xFFFF0000 : 0xFF008000,
                      onChanged: (inputPassword) {
                        setState(() {
                          passwordStrong =
                              rb.checkPasswordStrength(inputPassword);
                          if (passwordStrong) {
                            password = inputPassword;
                          }
                          print(passwordStrong);
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                          "Password should be minimum 8 characters long,with at least : \n 1 lowercase letter ,\n 1 Upper Case letter , \n 1 Digit and \n 1 Special Character"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextInput(
                      hint: 'Mobile',
                      borderColor: !mobileCorrect ? 0xFFFF0000 : 0xFF008000,
                      onChanged: (inputMobile) {
                        setState(() {
                          mobileCorrect = rb.checkMobile(inputMobile);
                          print(mobileCorrect);
                          if (mobileCorrect) {
                            mobile = inputMobile;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    RoundedButton(
                      buttonTitle: "Sign Up",
                      onPressed: () async {
                        setState(() {
                          _submitting = true;
                        });
                        if (nameCorrect &&
                            passwordStrong &&
                            emailCorrect &&
                            mobileCorrect) {
                          print("All Validations Successfull");
                          RegistrationBrain rb = RegistrationBrain(
                              name: name,
                              password: password,
                              email: email,
                              mobile: mobile);
                          Map reg = await rb.doRegistration();
                          print(reg);
                          late String warningMessage;
                          late String warningTitle;
                          if (reg['auth_exception'].toString() ==
                              Auth_Exceptions.REGISTRATION_SUCCESS.toString()) {
                            print('success');
                            warningMessage =
                                "Registration Successfull,Please confirm your email , and then login to continue..";
                            warningTitle = "REGISTRATION SUCCESSFULL";

                            Future.delayed(
                                Duration.zero,
                                () => SuccessAlertBox(
                                      context: context,
                                      title: warningTitle,
                                      messageText: warningMessage,
                                      buttonColor: Colors.blueAccent,
                                      titleTextColor: Colors.blueAccent,
                                    ));
                            Navigator.pushNamed(context, LoginScreen.id);
                          } else {
                            print('else');
                            if (reg['auth_exception'].toString() ==
                                Auth_Exceptions.EMAIL_ALREADY_EXISTS
                                    .toString()) {
                              print('email exists');
                              warningMessage =
                                  "Account already exists,Please try logging in";
                              warningTitle = "ACCOUNT ALREADY EXISTS";
                            } else if (reg['auth_exception'].toString() ==
                                Auth_Exceptions.NETWORK_ERROR.toString()) {
                              warningMessage =
                                  "Check your network and try again";
                              warningTitle = "NETWORK ERROR";
                            }
                            WarningAlertBox(
                              context: context,
                              messageText: warningMessage,
                              title: warningTitle,
                              buttonColor: Colors.blueAccent,
                              icon: Icons.warning,
                              titleTextColor: Colors.blue,
                            );
                          }
                        } else {
                          WarningAlertBox(
                            context: context,
                            messageText:
                                "Please Enter all the details properly",
                            title: "VALIDATION ERROR",
                            buttonColor: Colors.blueAccent,
                            icon: Icons.warning,
                            titleTextColor: Colors.blue,
                          );
                        }
                        setState(() {
                          _submitting = false;
                        });
                      },
                    ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account",
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
