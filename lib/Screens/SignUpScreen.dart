import 'package:flutter/material.dart';
import 'package:pg/componets/reuseWidgets.dart';
import 'package:pg/componets/Backend.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController Email = TextEditingController();
  final TextEditingController Uname = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final TextEditingController CnfPassword = TextEditingController();
  String message = "";

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffE5E6E4),
      appBar: AppBar(
        title: Text('Create Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
            width: screenWidth,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      reuseImage(),
                    ],
                  ),
                  resueLoginTextField(
                      text: 'Email',
                      icon: Icons.email_outlined,
                      isPasswordType: false,
                      controller: Email,
                      size: 370,
                      readonly: false),
                  const SizedBox(height: 10),
                  resueLoginTextField(
                      text: 'Username',
                      icon: Icons.person_outlined,
                      isPasswordType: false,
                      controller: Uname,
                      size: 370,
                      readonly: false),
                  const SizedBox(height: 10),
                  resueLoginTextField(
                      text: 'Password',
                      icon: Icons.lock_outline,
                      isPasswordType: true,
                      controller: Password,
                      size: 370,
                      readonly: false),
                  const SizedBox(height: 10),
                  resueLoginTextField(
                      text: 'Confirm Password',
                      icon: Icons.refresh_outlined,
                      isPasswordType: true,
                      controller: CnfPassword,
                      size: 370,
                      readonly: false),
                  const SizedBox(height: 10),
                  Text("$message",
                      style: TextStyle(fontSize: 15, color: Colors.red)),
                  SizedBox(height: 5.0),
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Backend b = Backend();
                        if (Email.text == "" ||
                            CnfPassword.text == "" ||
                            Password.text == "" ||
                            Uname == "")
                          message = "Enter all fields";
                        else if (!Email.text.endsWith("@gmail.com"))
                          message = "Please Enter Valid Email";
                        else if (Password.text != CnfPassword.text)
                          message = "Passward and Confirm Password Not Match";
                        else {
                          b.signup(
                              email: Email.text,
                              pwd: Password.text,
                              cnfPassword: CnfPassword.text,
                              role: widget.role,
                              unm: Uname.text);
                          Email.text = Password.text =
                              CnfPassword.text = Uname.text = "";
                          message = "";
                          final snackBar = SnackBar(
                            content: const Text('Your Account has been Created'),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                            ),
                          );
                          Navigator.pushReplacementNamed(context, '/login');
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        setState(() {
                          message;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0A1045),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Color(0xffe5e6e4),
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      link(text: "Sign In", context: context, path: '/login')
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
