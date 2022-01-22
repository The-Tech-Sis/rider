import 'package:dee_ride/all_screens/login_screen.dart';
import 'package:dee_ride/all_screens/signup_screen.dart';
import 'package:dee_ride/data_handler/app_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'all_screens/main_screen.dart';
import 'constants/constants.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


DatabaseReference usersRef = FirebaseDatabase.instance.reference().child(Constants.USER_COLLECTION);
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Bold-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainScreen.idScreen,
        routes: {
          SignUpScreen.idScreen: (context)=>SignUpScreen(),
          LoginScreen.idScreen: (context)=>LoginScreen(),
          MainScreen.idScreen: (context)=>MainScreen()


        }
      ),
    );
  }
}
