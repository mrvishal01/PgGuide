import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pg/Screens/HomeScreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  late BuildContext meracontext = context;
  void isLogin(meracontext) {
      Timer(
          const Duration(seconds: 3),
          (() => {
            Navigator.pushReplacement((meracontext),
                MaterialPageRoute(builder: (meracontext) => const HomeScreen(user:"null")))
          }));
    }
  @override
  void initState() {
    super.initState();
    isLogin(meracontext);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffE5E6E4),
        body: SafeArea(
          child: Center(
            child: Container(
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('Images/icon1.png', width: screenWidth),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      bottomNavigationBar: BottomAppBar(
        child:Container(
          color: Color(0xffE5E6E4),

          width:screenWidth,
          child:const Padding(
            padding : EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Developed By: Vaibhav Kishan Vishal",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Color(0xff0A1045)),),

              ]
        ),
          )
        ),
      ),
    );
  }
}
