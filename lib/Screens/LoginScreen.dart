import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pg/Screens/HomeScreen.dart';
import 'package:pg/Screens/OwnerHomeScreen.dart';
import 'package:pg/componets/reuseWidgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController Uname = TextEditingController();
  final TextEditingController Pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffE5E6E4),
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
          child: Container(
            width: screenWidth,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(child: reuseImage())],
              ),
              resueLoginTextField(
                  text: 'Email',
                  icon: Icons.person_outlined,
                  isPasswordType: false,
                  controller: Uname,
                  size: screenWidth,
                  readonly: false),
              const SizedBox(height: 7),
              resueLoginTextField(
                  text: 'Password',
                  icon: Icons.lock_outline,
                  isPasswordType: true,
                  controller: Pass,
                  size: screenWidth,
                  readonly: false),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    if (Uname.text == "" || Pass.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Enter all fields'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else if (!Uname.text.endsWith("@gmail.com")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Enter Email in proper format'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      final CollectionReference<Map<String, dynamic>>
                          productList =
                          FirebaseFirestore.instance.collection('manageUser');

                      AggregateQuerySnapshot Userquery = await productList
                          .where("Email", isEqualTo: Uname.text)
                          .where("Password", isEqualTo: Pass.text)
                          .where("Role", isEqualTo: "User")
                          .count()
                          .get();
                      AggregateQuerySnapshot Ownerquery = await productList
                          .where("Email", isEqualTo: Uname.text)
                          .where("Password", isEqualTo: Pass.text)
                          .where("Role", isEqualTo: "Owner")
                          .count()
                          .get();
                      if (Userquery.count == 1)
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(user: Uname.text),
                            ));
                      else if (Ownerquery.count == 1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OwnerHomeScreen(
                                admin: Uname.text,
                              ),
                            ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text('Message'),
                                  content: const Text(
                                    'Invalid Email or Password',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"))
                                  ]);
                            });
                      }
                    };
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0A1045),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                        color: Color(0xffe5e6e4),
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16, fontFamily: 'Montserrat',),
                  ),
                  link(text: "Sign Up", context: context, path: '/role')
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
