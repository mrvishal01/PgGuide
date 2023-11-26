import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pg/Screens/LoginScreen.dart';
import 'package:pg/Screens/RoleScreen.dart';
import 'package:pg/Screens/SplashScreen.dart';
import 'package:pg/componets/colors.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Stripe.publishableKey =
  "pk_test_51O258fSAYwVWBfMKHdlYeHq89rfFIi9n63xb3ysISWhmcbu4POCk2eenK5J26CGY4HirMK7KwxbrKB9ypRWrCtKu007esDeNGr";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "PG Guide",
      theme: ThemeData(
        primarySwatch:primary,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      routes : {
        '/' :(context) => const SplashScreen(),
        '/role':(context)=> const RoleScreen(),
        '/login':(context)=> const LoginScreen(),
      }
    );
  }
}
