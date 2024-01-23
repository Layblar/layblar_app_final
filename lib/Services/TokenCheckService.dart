import 'package:ass/Themes/Styles.dart';
import 'package:ass/screens/Login_Registration/LoginScreen.dart';
import 'package:flutter/material.dart';

class TokenCheckService{


  static void navigateBackIfTokenIsExpired(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return PopScope(
        canPop: false,
        child: AlertDialog(
          
          title: Text("Session Expired. Please log yourself in again.", style: Styles.infoBoxTextStyle,),
          actions: [
            ElevatedButton(onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen())), child: Text("Go to Log in", style: Styles.secondaryTextStyle,)),
          ],
        ),
      );
    });
  }
}