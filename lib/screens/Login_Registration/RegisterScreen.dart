import 'package:ass/API/APIController.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:ass/screens/Login_Registration/LoginScreen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  var firstmameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.primaryBackground,
        ),
        backgroundColor: ThemeColors.primaryBackground,
        body: getRegisterFormSection(context),
      ),
    );
  }

  Container getRegisterFormSection(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: Styles.containerDecoration,
        margin: const EdgeInsets.only(top: 8),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Let's Get Started!", style: Styles.headerTextStyle,),
              Text("Create an account to Layblar to get all features", style: Styles.regularTextStyle,),
              Container(
                decoration: Styles.primaryBackgroundContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField( 
                    style: Styles.regularTextStyle,
                    controller: firstmameController,
                    decoration:  InputDecoration(
                      iconColor: ThemeColors.primary,
                      hoverColor: ThemeColors.primary,
                      icon: const Icon(Icons.person),
                      labelText: ("Firstname *"),
                      labelStyle: Styles.regularTextStyle,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: Styles.primaryBackgroundContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField( 
                    style: Styles.regularTextStyle,
                    controller: lastnameController,
                    decoration:  InputDecoration(
                      iconColor: ThemeColors.primary,
                      hoverColor: ThemeColors.primary,
                      icon: const Icon(Icons.person_2),
                      labelText: ("Lastname *"),                           
                      labelStyle: Styles.regularTextStyle,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: Styles.primaryBackgroundContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField( 
                    style: Styles.regularTextStyle,
                    controller: firstmameController,
                    decoration:  InputDecoration(
                      iconColor: ThemeColors.primary,
                      hoverColor: ThemeColors.primary,
                      icon: const Icon(Icons.email),
                      labelText: ("Email *"),
                      labelStyle: Styles.regularTextStyle,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: Styles.primaryBackgroundContainerDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField( 
                    style: Styles.regularTextStyle,
                    controller: firstmameController,
                    obscureText: !showPassword, // Hier wird das Passwort verborgen oder angezeigt
                    decoration:  InputDecoration(
                      iconColor: ThemeColors.primary,
                      hoverColor: ThemeColors.primary,
                      icon: const Icon(Icons.lock),
                      labelText: ("Password *"),
                      labelStyle: Styles.regularTextStyle,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      suffixIcon: IconButton(
                            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: ThemeColors.textColor,),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                              debugPrint(showPassword.toString());
                            },
                ),
                    ),
                  ),
                ),
              ),
                
              Row(
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(style: Styles.errorButtonStyle, onPressed: ()=> Navigator.of(context).pop(), child: Text("Back to Login", style: Styles.secondaryTextStyle,)),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(style: Styles.primaryButtonStyle, onPressed: ()=> registerNewUser(firstmameController.text, lastnameController.text, emailController.text, passwordController.text), child: Text("Create", style: Styles.secondaryTextStyle,)),
                  )),
                ],
              )          
            ],
          ),
        ),
      );
  }


  Future<void> registerNewUser(String firstname, String lastname, String email, String password)async{

    String fname = firstmameController.text.trim();
    String lname = lastnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

      if (fname.isEmpty || lname.isEmpty || email.isEmpty || password.isEmpty) {
          BottomToast.showToast("Some Fields are missing!");
          return;
      }

      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)) {
        BottomToast.showToast("Invalid email format");
      return;
    }

    bool wasUserSuccessfullyRegistered = await APIController.registerHousehold(password, email, firstname, lastname);

    if(wasUserSuccessfullyRegistered){
      //showDialog, go To Login
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Registration was successful! Please Log in again.", style: Styles.infoBoxTextStyle,),
          actions: [
            ElevatedButton(style: Styles.primaryButtonRoundedStyle, onPressed: ()=> navigateToLogin(), child: Text("Go to Login", style: Styles.regularTextStyle,)),
          ],
          
        );
      });
    }else{
      //showDialog, try again
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("Regstration not successful, try again", style: Styles.infoBoxTextStyle,),
          actions: [
            ElevatedButton(style: Styles.errorButtonStyle, onPressed: ()=> Navigator.of(context).pop(), child: Text("Close", style: Styles.regularTextStyle,)),
          ],
          
        );
      });
    }
  }

  void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return const LoginScreen();
    }));
  }
}