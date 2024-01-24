import 'package:ass/API/APIController.dart';
import 'package:ass/HelperClasses/StopWatchHoldItem.dart';
import 'package:ass/DTO/TimerHoldItem.dart';
import 'package:ass/Themes/ThemeColors.dart';
import 'package:ass/screens/Login_Registration/LoginScreen.dart';
import 'package:ass/screens/MainScreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://drawable/logo',
    [
      NotificationChannel(
        channelGroupKey: 'layblar_notifications',
        channelKey: 'layblar',
        channelName: 'Layblar',
        channelDescription: 'Notification channel for layblars stopwatches',
        channelShowBadge: true,
        importance: NotificationImportance.High,
        enableVibration: true,
      ),
    ],
  );

  String? token = await APIController.getTokenFromSharedPreferences();

  bool checkToken(String? token){
    if(token != null){
      if(!JwtDecoder.isExpired(token)){
        return true;
      }
      return false;
    }else{
      return false;
    }
  }

  bool isTokenValid = checkToken(token);


  

  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StopwatchItemsModel()),
      ChangeNotifierProvider(create: (context) => TimerItemsModel())
    ],
    child: MyApp(initialRoute: isTokenValid ? '/main' : '/login')
    )
  );
}

class MyApp extends StatelessWidget {
    final String initialRoute;

  const MyApp({Key? key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: ThemeColors.primary,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: buildMaterialColor(ThemeColors.primary)),
      textTheme: TextTheme(
          bodyLarge: TextStyle(color: ThemeColors.textColor),
          bodyMedium: TextStyle(),
        ).apply(
          bodyColor: ThemeColors.textColor,
        ),
      ),
       initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),  
      },
    );
  }

  
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

