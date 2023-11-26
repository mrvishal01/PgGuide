import 'package:flutter/material.dart';
import 'package:pg/componets/CardImageSlider.dart';
import 'package:pg/componets/UserBottomNavigation.dart';
import '../componets/HomeListView.dart';

class HomeScreen extends StatefulWidget {
  final String user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String handle = "Login";
  @override
  void initState() {
    super.initState();
    if (widget.user == "null")
      handle = "Login";
    else
      handle = "Logout";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe5e6e4),
      appBar: AppBar(
        title: const Text("PG Guide"),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
          child: CircleAvatar(
            radius: 10.0,
            foregroundImage: AssetImage("Images/icon.jpg"),
          ),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () {
                if (widget.user == "null") {
                  Navigator.pushReplacementNamed(context, '/login');
                  handle = "Logout";
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen(user: "null")));
                  print(widget.user);
                }
                setState(() {});
              },
              icon: const Icon(Icons.login),
              label: Text("$handle", style: const TextStyle(fontFamily:'Montserrat',fontSize: 20,fontWeight: FontWeight.w600))),
          const SizedBox(width: 5)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          child: Column(
            children: [
              CardImageSlider(images: const [
                'Images/img_2.jpg',
                'Images/img_3.jpg',
                'Images/img_4.jpg',
                'Images/img_5.jpg'
              ]),
              const SizedBox(height: 2),
               SizedBox(
                child: HomeListView(user:widget.user),
                height: 500,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: UserBottomNavigation(
        user: widget.user,
      ),
    );
  }
}
