// ignore: file_names
import 'package:ass/API/APIController.dart';
import 'package:ass/HelperClasses/StatusCodes.dart';
import 'package:ass/Services/TokenCheckService.dart';
import 'package:ass/Themes/Styles.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/WIdgets/BottomToast.dart';
import 'package:ass/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RegisterSmartMeterScreen extends StatefulWidget {
  const RegisterSmartMeterScreen({super.key});

  @override
  State<RegisterSmartMeterScreen> createState() => _RegisterSmartMeterScreenState();
}

class _RegisterSmartMeterScreenState extends State<RegisterSmartMeterScreen> {

  var smartMeterIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.primaryBackground,
        body: Column(
          children: [
            Text("Please register a SmartMeter device.", style: Styles.headerTextStyle,),
            Text("Type in the Id on the label on your SmartMeter Device.", style: Styles.regularTextStyle,),
            Container(
              decoration: Styles.primaryBackgroundContainerDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField( 
                  style: Styles.regularTextStyle,
                  controller: smartMeterIdController,
                  decoration:  InputDecoration(
                    hoverColor: ThemeColors.primary,
                    labelText: ("Enter ID here"),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            ElevatedButton(style:Styles.primaryButtonStyle,  onPressed: ()=>registerSmartMeter(smartMeterIdController.text), child: Text('Register SmartMeter', style: Styles.regularTextStyle) )
          ],
        ),
      ),
    );
  }


  Future<void> registerSmartMeter(String smartMeterId) async{
    final String? token = await APIController.getTokenFromSharedPreferences();
    if(token != null){
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if(JwtDecoder.isExpired(token)){
          TokenCheckService.navigateBackIfTokenIsExpired(context);
        }else{
            String householdId = decodedToken['householdId'];

            int response = await APIController.registerSmartMeter(token, householdId, smartMeterId);


            debugPrint("[----smartmeterID----]$smartMeterId");
            
            if(response == StatusCodes.OK){
             BottomToast.showToast("Smartmeter successfullty Registered");
             Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const MainScreen()));
            }else if(response == StatusCodes.UNAUTHORIZED){
             BottomToast.showToast("STH STRANGE HAPPENED$response");
            }else if(response == StatusCodes.INVALID_USER){
            BottomToast.showToast("STH STRANGE HAPPENED$response");
            }else if(response == StatusCodes.SERVER_ERROR){
            BottomToast.showToast("STH STRANGE HAPPENED$response");
            }else{
            BottomToast.showToast("STH STRANGE HAPPENED$response");
            }
        }
    }
  }
}
