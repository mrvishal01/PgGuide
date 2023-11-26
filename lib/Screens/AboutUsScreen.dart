import 'package:flutter/material.dart';
import 'package:pg/componets/UserBottomNavigation.dart';
import 'package:pg/componets/reuseWidgets.dart';

class AboutUs extends StatelessWidget {
  final String user;
  const AboutUs({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e6e4),
      appBar: AppBar(title: const Text('About Us'),centerTitle: true,),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
    const SizedBox(height: 20,) ,     
              Image.asset(
                'Images/Vaibhav.jpeg',
                height: 155,
                width: 300,
              ),
              const SizedBox(
                height: 10,
              ),
              reuseAboutText(text: 'Vaibhav Yadav'),
              reuseAboutText(text: 'FullStack Developer'),
              const SizedBox(
                height: 20,
                width: 150,
                child: Divider(
                  color: Color(0xff0A1045),
                ),
              ),
              reuseAboutCard(
                  icon: Icons.phone_android_outlined, text: "+91 9638116330"),
              reuseAboutCard(
                  icon: Icons.email_outlined,
                  text: "yadavvaibhav2002@gmail.com"),

                      Image.asset(
                'Images/kishan.jpg',
                height: 155,
                width: 300,
              ),
              const SizedBox(
                height: 10,
              ),
              reuseAboutText(text: 'Kishan Yadav'),
              reuseAboutText(text: 'Node JS Developer'),
              const SizedBox(
                height: 20,
                width: 150,
                child: Divider(
                  color: Color(0xff0A1045),
                ),
              ),
              reuseAboutCard(
                  icon: Icons.phone_android_outlined, text: "+91 7623851072"),
              reuseAboutCard(
                  icon: Icons.email_outlined, text: "kishan09101@gmail.com"),
              Image.asset(
                'Images/Vishal.jpeg',
                height: 150,
                width: 300,
              ),
              const SizedBox(
                height: 10,
              ),
              reuseAboutText(text: 'Vishal Gupta'),
              reuseAboutText(text: 'Flutter Developer'),
              const SizedBox(
                height: 20,
                width: 150,
                child: Divider(
                  color: Color(0xff0A1045),
                ),
              ),
              reuseAboutCard(
                  icon: Icons.phone_android_outlined, text: "+91 7984687869"),
              reuseAboutCard(
                  icon: Icons.email_outlined, text: "guptavishal01@gmail.com"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: UserBottomNavigation(user: user),
    );
  }
}
