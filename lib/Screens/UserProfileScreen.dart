import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pg/Screens/HomeScreen.dart';
import 'package:pg/componets/UserBottomNavigation.dart';
import 'package:pg/componets/reuseWidgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pg/componets/Backend.dart';

class User {
  String name;
  String email;
  String Password;
  String InstaLink;

  User(
      {required this.name,
      required this.email,
      required this.Password,
      required this.InstaLink});
}

class UserProfileScreen extends StatefulWidget {
  final String user;

  const UserProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController instalink = TextEditingController();
  String id = '';

  User? currentUser;
  User? currentEmail;

  @override
  void initState() {
    super.initState();
    if (widget.user == "null") {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      fillData();
    }
  }

  void fillData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('manageUser').get().then((value) {
        for (var element in value.docs) {
          id = element.id;
          print(id);
          if (element.data()['Email'] == widget.user) {
            currentUser = User(
                name: element.data()['Username'],
                email: element.data()['Email'],
                Password: element.data()['ConfirmPassword'],
                InstaLink: element.data()['InstaLink']);

            name.text = currentUser!.name;
            email.text = currentUser!.email;
            pass.text = currentUser!.Password;
            instalink.text = currentUser!.InstaLink;
            break;
          }
        }
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E6E4),
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                radius: 55,
                foregroundImage: AssetImage('Images/icon.jpg'),
              ),
              const SizedBox(height: 10),
              resueLoginTextField(
                text: "UserName",
                icon: Icons.person_outline,
                isPasswordType: false,
                controller: name,
                size: 370,
                readonly: true,
              ),
              const SizedBox(height: 20),
              resueLoginTextField(
                text: 'Email',
                icon: Icons.email_outlined,
                isPasswordType: false,
                controller: email,
                size: 370,
                readonly: true,
              ),
              const SizedBox(height: 10),
              resueLoginTextField(
                text: 'Change Password',
                icon: Icons.password_outlined,
                isPasswordType: true,
                controller: pass,
                size: 370,
                readonly: false,
                
              ),
              const SizedBox(height: 20),
              resueLoginTextField(
                text: "Instagram Link",
                icon: FontAwesomeIcons.instagram,
                isPasswordType: false,
                controller: instalink,
                size: 350,
                readonly: false,
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Backend b = Backend();
                    if (instalink.text == "") {
                      b.UpdateUserProfile(
                          ChangePassword: pass.text,
                          InstaLink: "Not Given",
                          id: id);
                    } else {
                      b.UpdateUserProfile(
                          ChangePassword: pass.text,
                          InstaLink: instalink.text,
                          id: id);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: reuseSnackBarMessageText(
                            Message: "Your Data Updated Successfully!!"),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          user: widget.user,
                                        )));
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0A1045),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                        color: Color(0xffe5e6e4),
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: UserBottomNavigation(user: widget.user),
    );
  }
}
