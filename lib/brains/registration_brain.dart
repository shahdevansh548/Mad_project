// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper_example/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class RegistrationBrain {
  Map registrationUpdate = {};
  late String? name, email, password, mobile;
  RegExp regExpForPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  RegExp regExpForEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  RegistrationBrain({this.name, this.email, this.password, this.mobile});

  bool checkPasswordStrength(String pass) {
    if (pass.trim().length <= 7) {
      return false;
    }
    if (regExpForPassword.hasMatch(pass)) {
      return true;
    }
    return false;
  }

  bool checkMobile(String mob) {
    if (mob.trim().length <= 9) {
      return false;
    }
    return true;
  }

  bool checkEmail(String e) {
    if (regExpForEmail.hasMatch(e.trim())) {
      return true;
    }
    return false;
  }

  bool checkName(String n) {
    if (n.trim().isNotEmpty && n.trim().length > 5) {
      return true;
    }
    return false;
  }

  Future<Map> doRegistration() async {
    try {
      final list = await _auth.fetchSignInMethodsForEmail(email.toString());
      if (list.isEmpty) {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email.toString(), password: password.toString());
        if (newUser != null) {
          _firestore
              .collection('users')
              .doc(email)
              .set({'uid': newUser.user?.uid, 'name': name, 'mobile': mobile});
          await newUser.user!.sendEmailVerification();
        }
        print("Registration Successfull");
        registrationUpdate['auth_exception'] =
            Auth_Exceptions.REGISTRATION_SUCCESS;
        registrationUpdate['user'] = newUser;
        return registrationUpdate;
      } else {
        registrationUpdate['auth_exception'] =
            Auth_Exceptions.EMAIL_ALREADY_EXISTS;
        return registrationUpdate;
      }
    } catch (e) {
      print(e);
      registrationUpdate['auth_exception'] = Auth_Exceptions.NETWORK_ERROR;
      return registrationUpdate;
    }
  }
}
