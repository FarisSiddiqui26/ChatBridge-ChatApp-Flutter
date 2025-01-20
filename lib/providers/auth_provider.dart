import 'package:chatbridge/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/snackbar_Service.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error
}

class AuthProvider extends ChangeNotifier {
  User? user;
  AuthStatus status = AuthStatus.Authenticated;
  FirebaseAuth? _auth;

  static AuthProvider instance = AuthProvider();
  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  void loginUserWithEmialAndPassword(String _email, String _password) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth!.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user!;
      status = AuthStatus.Authenticated;
      SnackbarService.instance.showSnackBarSuccess("Welcome , ${user!.email}");
     NavigationService.instance.navigateTo("home");
    } catch (e) {
      status = AuthStatus.Error;
      SnackbarService.instance.showSnackBarError("Error Authenticating");
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth!.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      await onSuccess(user!.uid);
      SnackbarService.instance.showSnackBarSuccess("Welcome , ${user!.email}");
     NavigationService.instance.navigateTo("register");
    } catch (e) {
      print("Error registering user");
      status = AuthStatus.Error;
      user = null;
      SnackbarService.instance.showSnackBarError("Error Registering User");
    }
    notifyListeners();
  }
}
