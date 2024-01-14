import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

const timeout = const Duration(seconds: 3);

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 10000), () {
      Navigator.pop(context);
    });
    return Scaffold(
      body: Image.network(
          'https://cdn.dribbble.com/users/1056629/screenshots/2482134/bw-4.gif'),
    );
  }
}
