import 'package:ass/API/APIController.dart';
import 'package:ass/DTO/Household/HouseholdDTO.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:ass/screens/MainScreen.dart';
import 'package:ass/screens/Login_Registration/RegisterScreen.dart';
import 'package:ass/screens/Login_Registration/RegisterSmartMeterScreen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

      bool showPassword = false;


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ThemeColors.primaryBackground,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(flex: 4, 
                child: getHeaderSection()
              ),
              Expanded(flex: 6, 
                child: getLoginFormSection()
              )
            ],
          ),
        ),
      ),
    );
  }




  Container getLoginFormSection() {

    return Container(
              decoration: BoxDecoration(
                color: ThemeColors.secondaryBackground,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back!", style: Styles.headerTextStyle,),
                    Row(
                      children: [
                        Text("No Account?", style: Styles.regularTextStyle,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GestureDetector(
                            onTap: ()=> navigateToRegisterScreen(),
                            child: Text("Register here.", style: Styles.regularTextStylePrimaryColor,)),
                        ),
                      ],
                    ),
                    Container(
                      decoration: Styles.primaryBackgroundContainerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          style: Styles.regularTextStyle,
                          controller: usernameController,
                          decoration:  InputDecoration(
                            iconColor: ThemeColors.primary,
                            hoverColor: ThemeColors.primary,
                            icon: const Icon(Icons.email),
                            labelText: ("Email"),
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
                          controller: passwordController,
                          obscureText: !showPassword, // Hier wird das Passwort verborgen oder angezeigt
                          decoration: InputDecoration(
                            iconColor: ThemeColors.primary,
                            icon: const Icon(Icons.lock),
                            labelText: ("Password"),
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
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(onPressed: ()=> validateUserAndLogin(), style: Styles.primaryButtonStyle, child: Text("Login", style: Styles.secondaryTextStyle,)),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            );
  }


Future<void> validateUserAndLogin() async {
  // Überprüfen, ob Benutzername und Passwort nicht leer sind
  String email = usernameController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    BottomToast.showToast("Username and password cannot be empty");
    return;
  }

  // Überprüfen, ob die E-Mail-Adresse ein gültiges Format hat
  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email)) {
    BottomToast.showToast("Invalid email format");
    return;
  }

  // Versuchen Sie, sich anzumelden
  //int response = await APIController.login(email, password);
    int response = await APIController.login("lorenzrichard@gmx.at", "testtest");


  if (APIController.isReponseValid(response)) {
    // Überprüfen, ob es einen Smart Meter gibt
    String? token = await APIController.getTokenFromSharedPreferences();

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (JwtDecoder.isExpired(token)) {
      } else {
        String householdId = decodedToken['householdId'];

        HouseholdDTO? householdDTO = await APIController.getHousehold(token, householdId);

        if (householdDTO!.smartmeters.isEmpty) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const RegisterSmartMeterScreen()));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const MainScreen()));
        }
      }
    }
  } else {
    BottomToast.showToast("Invalid username or password");
  }
}


void navigateToRegisterScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: ((BuildContext context) => const RegisterScreen())));
}


  Container getHeaderSection() {
    return Container(
              color: ThemeColors.primaryBackground,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Layblar", style: Styles.headerTextStyle,),
                  Text("Life is hard, Layble smart!", style: Styles.regularTextStyle,)
                ],
              ),
            );
  }
}

