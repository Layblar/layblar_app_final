import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ass/Themes/ThemeColors.dart';

class BlinkingDotWidget extends StatefulWidget {
  final bool isRunning;

  BlinkingDotWidget({required this.isRunning});

  @override
  _BlinkingDotWidgetState createState() => _BlinkingDotWidgetState();
}

class _BlinkingDotWidgetState extends State<BlinkingDotWidget> {
  late Timer _blinkTimer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (widget.isRunning) {
        setState(() {
          _isVisible = !_isVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && _isVisible) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: ThemeColors.error,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return const SizedBox(
        width: 20,
        height: 20,
      );
    }
  }
}