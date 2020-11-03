import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Image(
        image: AssetImage('assets/images/logo_full.png'),
      ),
    );
  }
}
