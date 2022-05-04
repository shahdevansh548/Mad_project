// ignore_for_file: camel_case_types, avoid_print, body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper_example/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class Login_Brain {
  Map<String, dynamic> loginUpdate = {};
  String email, password, name = '', mobile = '';
  Login_Brain({this.email = '', this.password = ''});

  Future<Map<String, dynamic>> doLogin() async {
    try {
      final currentUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!currentUser.user!.emailVerified) {
        loginUpdate['auth_exception'] = Auth_Exceptions.EMAIL_NOT_VERIFIED;
        return loginUpdate;
      }
      print(currentUser.credential);
      final userDetail = await _firestore.collection('users').doc(email).get();
      print(userDetail.data());
      loginUpdate['auth_exception'] = Auth_Exceptions.LOGIN_SUCCESSFULL;
      loginUpdate['email'] = email;
      loginUpdate['password'] = password;
      loginUpdate['name'] = await userDetail.data()?['name'];
      loginUpdate['mobile'] = await userDetail.data()?['mobile'];
      return loginUpdate;
    } catch (e) {
      print(e.hashCode);
      print(e);
      if (e.hashCode == 185768934) {
        loginUpdate['auth_exception'] = Auth_Exceptions.INVALID_PASSWORD;
        return loginUpdate;
      } else if (e.hashCode == 360587416 || e.hashCode == 505284406) {
        loginUpdate['auth_exception'] = Auth_Exceptions.ACCOUNT_NOT_FOUND;
        return loginUpdate;
      }
      loginUpdate['auth_exception'] = Auth_Exceptions.NETWORK_ERROR;
      return loginUpdate;
    }
  }

  Future<User?> doLoginUsingGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await _auth.signInWithCredential(authCredential);
      User? user = result.user;
      if (user != null) {
        print(user);
        return user;
      }

      // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  Future doLogOutOfGoogle() async {
    var logout = await _googleSignIn.signOut();
    print(logout);
    return logout;
  }

  Future<Auth_Exceptions> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Auth_Exceptions.RESET_LINK_SENT;
    } catch (e) {
      print(e.hashCode);
      print(e);
      if (e.hashCode == 360587416) {
        return Auth_Exceptions.INVALID_EMAIL;
      } else if (e.hashCode == 505284406) {
        return Auth_Exceptions.ACCOUNT_NOT_FOUND;
      }
      return Auth_Exceptions.NETWORK_ERROR;
    }
  }
}
