import 'package:chatbridge/pages/loginpage.dart';
import 'package:chatbridge/providers/auth_provider.dart';
import 'package:chatbridge/services/database_service.dart';
import 'package:chatbridge/services/snackbar_Service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/navigation_service.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/cloud_storage_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  double? _deviceHeight;
  double? _deviceWidth;

  bool _passwordvisible = false;

  GlobalKey<FormState>? _formkey;
  XFile? _image;

  AuthProvider? _auth;

  String? _name;
  String? _email;
  String? _password;

  FilePickerResult? _filePickerResult;
  @override
  void initState() {
    super.initState();
    _passwordvisible = false;
  }

  _RegistrationPageState() {
    _formkey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
          alignment: Alignment.center,
          child: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance,
            child: registrationPageUI(),
          )),
    );
  }

  Widget registrationPageUI() {
    return SingleChildScrollView(
      child: Builder(builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return Container(
          height: _deviceHeight! * 0.89,
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headingWidget(),
              _selectImageText(),
              _inputform(),
              SizedBox(
                height: _deviceHeight! * 0.01,
              ),
              _registerButton(),
              _backtoLoginPageButton()
            ],
          ),
        );
      }),
    );
  }
Widget _selectImageText(){
  return Container(
    height: _deviceHeight!*0.04,
    child: Row(
      children: [
                Text(
            "Select your image",
            style: TextStyle(fontSize: 17),
          )
      ],
    ),
  );
}
  Widget _headingWidget() {
    return Container(
      height: _deviceHeight! * 0.13,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please enter your details",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),

        ],
      ),
    );
  }

  Widget _nameTextfield() {
    return TextFormField(
      autocorrect: false,
      style: const TextStyle(color: Colors.white),
      validator: (_input) {
        if (_input!.length != 0) {
          return null;
        } else {
          return "Please enter a name";
        }
      },
      onSaved: (_input) {
        setState(() {
          _name = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
          hintText: 'Name',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }

  Widget _emailTextfield() {
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
          _email = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: const InputDecoration(
          hintText: 'Email Addresss',
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
          _password = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(
              _passwordvisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _passwordvisible = !_passwordvisible;
              });
            },
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
    );
  }

  Widget _inputform() {
    return Container(
      height: _deviceHeight! * 0.5,
      child: Form(
          key: _formkey,
          onChanged: () {
            _formkey!.currentState!.save();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageSelectorWidget(),
              _nameTextfield(),
              _emailTextfield(),
              _passwordTextField(),
            ],
          )),
    );
  }

  Widget _imageSelectorWidget() {
  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ["jpg", "jpeg", "png"],
      type: FileType.custom,
    );
    setState(() {
      _filePickerResult = result;
    });
  }
  return Align(
    alignment: Alignment.center,
    child: GestureDetector(
      onTap: () {
        _openFilePicker();
      },
      child: _filePickerResult != null
          ? Container(
              height: _deviceHeight! * 0.18,
              width: _deviceWidth! * 0.35,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: FileImage(File(_filePickerResult!.files.single.path!)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              height: _deviceHeight! * 0.18,
              width: _deviceWidth! * 0.35,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                      image: AssetImage("assets/images/registration2.png"),
                      fit: BoxFit.fill)),
            ),
    ),
  );
}

  Widget _registerButton() {
    return _auth!.status != AuthStatus.Authenticating
        ? Container(
            height: _deviceHeight! * 0.06,
            width: _deviceWidth,
            child: MaterialButton(
              onPressed: () {
                if (_formkey!.currentState!.validate() && _filePickerResult != null) {
                  _auth!.registerUserWithEmailAndPassword(_email!, _password!,
                      (String _uid) async {
                    if (_filePickerResult != null) {
                      File imageFile = File(_filePickerResult!.files.single.path!);
                      String? _imageURL = await CloudStorageService.instance.uploadUserImage(imageFile);

                      if (_imageURL != null) {
                        await DBService.instance.createUserInDB(_uid, _name!, _email!, _imageURL);
                        // NavigationService.instance.navigateTo('home');
                      } else {
                        // Handle the case if image upload fails
                        SnackbarService.instance.showSnackBarError("Image upload failed");
                      }
                    }
                  });
                }
              },
              color: Colors.blue,
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          )
        : Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
  }

  Widget _backtoLoginPageButton() {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.goBack();
      },
      child: Container(
        height: _deviceHeight! * 0.06,
        width: _deviceWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_back,
            size: 40,
          ),
        ),
      ),
    );
  }
}
