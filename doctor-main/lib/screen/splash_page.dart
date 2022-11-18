import 'package:flutter/material.dart';
import 'package:toseeadoctor/main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Image.asset(
          'assets/icon/icon.png',
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void navigate() async {
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }
}
