import 'package:dee_ride/all_screens/main_screen.dart';
import 'package:dee_ride/all_screens/signup_screen.dart';
import 'package:dee_ride/all_widgets/progress_dialog.dart';
import 'package:dee_ride/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {

  static const String idScreen = 'login';
  TextEditingController emailTextEditingController =  TextEditingController();
  TextEditingController passwordTextEditingController =  TextEditingController();
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

            Text('Log in as a rider',
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
                      'Log in',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                    onPressed: (){
                      if(!emailTextEditingController.text.contains('@')){
                        displayToast('Email is invalid', context);
                        }else if(passwordTextEditingController.text.length<6){
                        displayToast('Password must be at least 6 characters', context);
                      }
                      loginAndAuthenticate(context);
                    }
                  ),
                ],
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Brand Bold'
                  ),
                ),
                TextButton(
                  child: Text(
                      'Sign up',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Brand Bold',
                      fontWeight: FontWeight.bold
                    )
                  ),
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context,
                        SignUpScreen.idScreen,
                            (route)=>false);
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
  loginAndAuthenticate(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:(BuildContext context){
        return ProgressDialog(message: 'Authenticating, Please wait...',);
      }
    );
    _firebaseAuth.signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    ).then((UserCredential credential) {
      if(credential != null){
        usersRef.child(credential.user.uid).once()
            .then((_)=>(DataSnapshot snapshot){
            if(snapshot.value !=null){


            }
        });
      }else{
        Navigator.pop(context);
        _firebaseAuth.signOut();
        displayToast('No records for this user, create new account ', context);

      }
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen,(route)=> false);
      displayToast('Logged in', context);
    }).catchError((e) {
      displayToast('Error: ${e}', context);
    });


  }
  displayToast(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
