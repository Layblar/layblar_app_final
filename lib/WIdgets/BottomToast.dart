import 'package:ass/Themes/ThemeColors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomToast{
   static void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: ThemeColors.primary,
    textColor: ThemeColors.textColor,
    fontSize: 16.0,
  );
   }
}