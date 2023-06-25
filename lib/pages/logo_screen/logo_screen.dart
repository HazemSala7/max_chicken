import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trendyol/server/function/functions.dart';
import '../../constants/constants.dart';
import '../home_screen/home_screen.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      currentIndex: 0,
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 200.0, left: 20, right: 20),
                  child: Center(
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.3,
                      // width: 250,
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: InkWell(
                    child: Text(
                      'Powered By Hazem Salah',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
