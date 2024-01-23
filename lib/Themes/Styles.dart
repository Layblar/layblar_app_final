import 'package:ass/Themes/ThemeColors.dart';
import 'package:flutter/material.dart';
class Styles{

  static final primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: TextStyle(color: ThemeColors.textColor),

  );

  static final primaryButtonRoundedStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.primary,
    shape: const CircleBorder(),
    padding: const EdgeInsets.all(8),
    textStyle: TextStyle(color: ThemeColors.textColor),

  );

  static final secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.secondary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: TextStyle(color: ThemeColors.textColor)
  );

  static final tertiaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.tertiary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: TextStyle(color: ThemeColors.textColor)
  );

  static final errorButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: ThemeColors.error,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: TextStyle(color: ThemeColors.textColor)
  );

  static final containerDecoration = BoxDecoration(
    color: ThemeColors.secondaryBackground,
    borderRadius: BorderRadius.circular(16)
  );

   static final selctedContainerDecoration = BoxDecoration(
    color: ThemeColors.primary,
    borderRadius: BorderRadius.circular(16)
  );

  static final primaryBackgroundContainerDecoration = BoxDecoration(
    color: ThemeColors.primaryBackground,
    borderRadius: BorderRadius.circular(16)
  );


  static final stopwatchContainerDecoration = BoxDecoration(
    color: ThemeColors.primary,
    borderRadius: BorderRadius.circular(200),
    boxShadow: [
      BoxShadow(
        color: ThemeColors.primary.withOpacity(0.4),
        spreadRadius: 5,
        blurRadius: 7,
        offset:  Offset(0, 3)
        )
    ]
  );

  static final stopwatchContainerDecorationStopped = BoxDecoration(
    color: ThemeColors.error,
    borderRadius: BorderRadius.circular(200),
    boxShadow: [
      BoxShadow(
        color: ThemeColors.error.withOpacity(0.4),
        spreadRadius: 5,
        blurRadius: 7,
        offset:  Offset(0, 3)
        )
    ]
  );

    static final infoBoxTextStyle =  TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ThemeColors.textColor,
  );

  static final headerTextStyle = TextStyle(
    fontSize: 36,
    color: ThemeColors.textColor
  );

  static final headerTextStyleSecondary = TextStyle(
    fontSize: 36,
    color: ThemeColors.secondaryBackground,
    fontWeight: FontWeight.bold
  );

  static final regularTextStyle = TextStyle(
    color: ThemeColors.textColor
  );

  static final secondaryTextStyle = TextStyle(
    color: ThemeColors.primaryBackground
  );


    static final regularTextStylePrimaryColor = TextStyle(
    color: ThemeColors.primary
  );
}

