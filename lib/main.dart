import 'package:chatbridge/firebase_options.dart';
import 'package:chatbridge/pages/profile_screen.dart';
import 'package:chatbridge/services/database_service.dart';
import 'package:chatbridge/services/snackbar_Service.dart';
import 'package:chatbridge/wrapper.dart';
import 'package:flutter/material.dart';
import'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './pages/loginpage.dart';
import'package:firebase_core/firebase_core.dart';
import './providers/auth_provider.dart';
import 'package:chatbridge/pages/registration_page.dart';
import './services/navigation_service.dart';
import './pages/Homescreen.dart';

late Size mq;
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.bottom,SystemUiOverlay.top]);
   await dotenv.load(fileName: ".env");
   await Firebase.initializeApp();
  runApp(
    const MyApp());
}
class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
       return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_)=>AuthProvider(),)
      ],
      child: MaterialApp(
        scaffoldMessengerKey: SnackbarService.instance.scaffoldMessengerKey,
        title: 'Chat Bridge',

        navigatorKey: NavigationService.instance.navigatorKey,
        theme: ThemeData(
          appBarTheme:AppBarTheme(
          centerTitle: true,
        elevation: 4,        
        backgroundColor: Colors.indigoAccent,
        titleTextStyle:TextStyle(
          fontSize: 19,
        )
          ),
         brightness: Brightness.dark,
         primaryColor: Color.fromRGBO(42, 117, 188, 1),
         scaffoldBackgroundColor: Color.fromRGBO(28, 27, 27, 1), 
         hintColor:  Color.fromRGBO(42, 117, 188, 1),
        
        ),
        
        initialRoute: "Login",
      routes: {
        "login":(BuildContext _context)=> Loginpage(),
        "home":(BuildContext _context)=> Homescreen(),
        "register":(BuildContext _context)=> RegistrationPage(),
        // "profile":(BuildContext _context)=> Profilescreen(),
      
      },
       home: const Wrapper(),
       debugShowCheckedModeBanner: false,
       
       
      ),
    );
  }
}

