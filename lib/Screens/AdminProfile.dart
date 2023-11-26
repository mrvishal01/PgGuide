import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pg/Screens/OwnerHomeScreen.dart';
import 'package:pg/componets/Backend.dart';
import 'package:pg/componets/OwnerBottomNavigation.dart';
import 'package:pg/componets/reuseWidgets.dart';

class Admin {
  String name;
  String email;
  String Password;
  String InstaLink;
  String ContactNo;

  Admin(
      {required this.name,
      required this.email,
      required this.Password,
      required this.InstaLink,
      required this.ContactNo});
}

class AdminProfile extends StatefulWidget {
  final String admin;
  const AdminProfile({Key? key, required this.admin}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final TextEditingController name = TextEditingController();
  final TextEditingController Email = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController InstaLink = TextEditingController();
  String id = "";

  Admin? currentAdmin;
  Admin? currentEmail;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('manageUser').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['Email'] == widget.admin) {
            id = element.id;
            print(id);
            currentAdmin = Admin(
                name: element.data()['Username'],
                email: element.data()['Email'],
                Password: element.data()['ConfirmPassword'],
                InstaLink: element.data()['InstaLink'],
                ContactNo: element.data()["ContactNo"]);

            name.text = currentAdmin!.name;
            Email.text = currentAdmin!.email;
            Password.text = currentAdmin!.Password;
            InstaLink.text = currentAdmin!.InstaLink;
            contact.text = currentAdmin!.ContactNo;
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
        title: const Text('Admin Profile '),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(children: [
            const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: 55,
              foregroundImage: AssetImage('Images/icon.jpg'),
            ),
            const SizedBox(height: 10),
            resueLoginTextField(
                text: 'UserName',
                icon: Icons.people_alt_outlined,
                isPasswordType: false,
                controller: name,
                size: 370,
                readonly: true),
            const SizedBox(height: 10),
            resueLoginTextField(
                text: 'Email',
                icon: Icons.email_outlined,
                isPasswordType: false,
                controller: Email,
                size: 370,
                readonly: true),
            const SizedBox(height: 10),
            resueLoginTextField(
                text: 'Contact Number',
                icon: Icons.call_outlined,
                isPasswordType: false,
                controller: contact,
                size: 370,
                readonly: false),
            const SizedBox(height: 10),
            resueLoginTextField(
                text: 'Change Password',
                icon: Icons.password_outlined,
                isPasswordType: true,
                controller: Password,
                size: 370,
                readonly: false),
            const SizedBox(height: 20),
            resueLoginTextField(
                text: "Instagram Link",
                icon: FontAwesomeIcons.instagram,
                isPasswordType: false,
                controller: InstaLink,
                size: 370,
                readonly: false),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Backend b = Backend();
                  if (InstaLink.text == "" || contact.text == "To be updated" || contact.text == "") {
                    b.UpdateAdminProfile(
                        ChangePassword: Password.text,
                        InstaLink: "Not Given",
                        Contact: "To be updated",
                        Email:Email.text,
                        id: id);
                  } else {
                    b.UpdateAdminProfile(
                        ChangePassword: Password.text,
                        InstaLink: InstaLink.text,
                        Contact: contact.text,
                        Email: Email.text,
                        id: id);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                    children: [
                      const Text("Your Data Updated Successfully!!"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OwnerHomeScreen(
                                    admin: widget.admin,
                                  ),
                                ));
                          },
                          child: const Text("ok"))
                    ],
                  )));
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
          ]),
        ),
      ),
      bottomNavigationBar: OwnerBottomNavigationBar(admin: widget.admin),
    );
  }
}
