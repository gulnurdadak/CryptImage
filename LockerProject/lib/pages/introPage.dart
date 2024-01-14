import 'package:flutter/material.dart';
import 'package:lockerproject/pages/HomePage.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

const timeout = const Duration(seconds: 3);

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3250), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/introbg.jpg",
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/logo.png",
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
