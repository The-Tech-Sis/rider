import 'package:dee_ride/all_screens/main_screen.dart';
import 'package:dee_ride/all_widgets/progress_dialog.dart';
import 'package:dee_ride/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dee_ride/constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';
import 'package:dee_ride/main.dart';
import 'main_screen.dart';

class SignUpScreen extends StatelessWidget {

  static const String idScreen = 'signup';
  TextEditingController nameTextEditingController =  TextEditingController();
  TextEditingController emailTextEditingController =  TextEditingController();
  TextEditingController passwordTextEditingController =  TextEditingController();
  TextEditingController phoneTextEditingController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height:35.0),
            Image(
              image: AssetImage('images/logo.png'),
              width: 390.0,
              height: 250.0,
              alignment: Alignment.center,
            ),

            SizedBox(height:15.0),

            Text('Sign up as a rider',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Brand Bold'
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[

                  SizedBox(height:1.0),

                  TextField(
                    controller:  nameTextEditingController,
                    decoration:  InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(
                      fontSize: 14.0,

                    ),
                  ),
                  SizedBox(height:1.0),

                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(
                      fontSize: 14.0,

                    ),
                  ),

                  SizedBox(height:1.0),

                  TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration:  InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(
                      fontSize: 14.0,

                    ),
                  ),

                  SizedBox(height: 1.0,),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration:  InputDecoration(
                        labelText: 'Password ',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(
                      fontSize: 14.0,

                    ),
                  ),
                  SizedBox(height: 5.0,),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        shape: new RoundedRectangleBorder(
                          borderRadius:  new BorderRadius.circular(24.0),

                        ),
                        primary: Colors.yellow[600],
                      ),
                      child: Text(
                        'Create User',
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                      onPressed: (){
                        if(nameTextEditingController.text.length<4){
                          displayToast(
                              'Name must be at least 3 characters',
                              context
                          );
                        }else if(!emailTextEditingController.text.contains('@')){
                          displayToast('Email is invalid', context);
                        }else if(phoneTextEditingController.text.isEmpty){
                          displayToast('Phone number field is empty', context);
                        }else if(passwordTextEditingController.text.length<7){
                          displayToast('Password must be at least 6 characters', context);
                        }
                        else{
                          registerNewUser(context);

                        }
                      }
                  ),
                ],
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Brand Bold'
                  ),
                ),
                TextButton(
                  child: Text(
                      'Log in',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Brand Bold',
                          fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: (){

                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen,(route)=> false);

                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerNewUser(BuildContext context)async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return ProgressDialog(message: 'Authenticating, Please wait...',);
        }
    );
   _firebaseAuth.createUserWithEmailAndPassword(
     email: emailTextEditingController.text,
     password: passwordTextEditingController.text
   ).then((UserCredential credential){

     print(credential.user.uid);

     if(credential !=null){
       Map  userDataInfo = {
         Constants.USER_EMAIL: emailTextEditingController.text.trim(),
         Constants.USER_NAME:nameTextEditingController.text.trim(),
         Constants.USER_PHONE:phoneTextEditingController.text.trim(),
       };

       usersRef.child(credential.user.uid).set(userDataInfo);
       displayToast('Congratulations user with name:'
           '${nameTextEditingController.text}, email:'
           ' ${emailTextEditingController.text} has been created',
           context);

       Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen,(CupertinoPageRoute)=> false);
     }else{
       displayToast('New user account has not been created', context);
     }


   }).catchError((e){
     print(e);
   });


  }

  displayToast(String message,BuildContext context){
    Fluttertoast.showToast(msg:message);
  }
}
