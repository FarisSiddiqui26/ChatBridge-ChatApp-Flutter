import 'package:chatbridge/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as local_auth_provider;
import '../services/snackbar_Service.dart';
import '../services/navigation_service.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  double _deviceWidth = 0;
  double _deviceHeight = 0;
  bool _passwordvisible=false;
  String _email = '';
  String _password = '';
  GlobalKey<FormState>? _formkey;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    
    super.initState();
    _passwordvisible = false;
    _auth.authStateChanges().listen(
      (event) {
        if (mounted) {
          setState(() {
            _user = event;
          });
        }
      },
      onError: (error) {
        debugPrint('Error in authStateChanges: $error');
      },
    );
  }

  _LoginpageState() {
    _formkey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Align(
          alignment: Alignment.center,
          child: ChangeNotifierProvider<local_auth_provider.AuthProvider>.value(
            value: local_auth_provider.AuthProvider.instance,
            child: _loginPageUI(),
          )),
    );
  }

  Widget _loginPageUI() {
    return SingleChildScrollView(
      child: Builder(builder: (BuildContext _context) {
       var _auth = Provider.of<local_auth_provider.AuthProvider>(_context);
        print(_auth.user);
        return Container(
          height: _deviceHeight * 0.90,
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headingWidget(),
              _inputform(),
              _loginButton(),
              _registerButton(),
              Row(children: <Widget>[
                Expanded(
                    child: Divider(
                  color: Colors.white,
                )),
                Text('OR',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'poppinsmedium')),
                const Expanded(
                    child: Divider(
                  color: Colors.white,
                )),
              ]),
              _googleButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _headingWidget() {
    return Container(
      height: _deviceHeight * 0.19,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back!",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please login into your account",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          )
        ],
      ),
    );
  }

  Widget _inputform() {
    return Container(
      height: _deviceHeight * 0.25,
      child: Form(
          key: _formkey,
          onChanged: () {
            _formkey!.currentState?.save();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _emailTextField(),
              _passwordTextField(),
            ],
          )),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      autocorrect: false,
      style: const TextStyle(color: Colors.white),
      validator: (_input) {
        if (_input!.length != 0 && _input.contains("@")) {
          return null;
        } else {
          return "Please enter a valid email";
        }
      },
      onSaved: (_input) {
        setState(() {
          _email = _input!;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
          hintText: 'Email Address',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: !_passwordvisible,
      autocorrect: false,
      style: const TextStyle(color: Colors.white),
      validator: (_input) {
        return _input!.length != 0 ? null : "Please enter a password";
      },
      onSaved: (_input) {
        setState(() {
          _password = _input!;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(
              _passwordvisible
              ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: (){
              setState(() {
                _passwordvisible=!_passwordvisible;
              });
            },
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }

  Widget _loginButton() {
    if (local_auth_provider.AuthProvider().status ==
        local_auth_provider.AuthStatus.Authenticating) {
      return Align(
          alignment: Alignment.center, child: CircularProgressIndicator());
    } else {
      return Container(
        height: _deviceHeight * 0.06,
        width: _deviceWidth,
        child: MaterialButton(
          onPressed: () {
            if (_formkey!.currentState!.validate()) {
              var _auth = Provider.of<local_auth_provider.AuthProvider>(
                context,
                listen: false,
              );
              _auth.loginUserWithEmialAndPassword(_email, _password);
            }
          },
          color: Colors.blue,
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
  }

  Widget _registerButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigateTo('register');
      },
      child: Container(
        height: _deviceHeight * 0.03,
        width: _deviceWidth,
        child: Text(
          'REGISTER',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white60),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return Center(
      child: SizedBox(
        height: _deviceHeight * 0.05,
        child: SignInButton(Buttons.google, onPressed: (() => _googleLogin())),
      ),
    );
  }

  _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google sign-in canceled.");
        return; // User canceled the login
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await APIs.auth.signInWithCredential(credential);
      print("User signed in successfully.");

      if ((await APIs.userExist())) {
          NavigationService.instance.navigateTo('home');
        
      }
      else{
        APIs.Createuser().then((value){
          NavigationService.instance.navigateTo('home');

        });
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
    }
  }
}
