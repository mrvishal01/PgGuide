import 'package:flutter/material.dart';
import 'package:pg/Screens/AboutUsScreen.dart';
import 'package:pg/Screens/BookingDetail.dart';
import 'package:pg/Screens/HomeScreen.dart';
import 'package:pg/Screens/SearchScreen.dart';
import 'package:pg/Screens/UserProfileScreen.dart';

class UserBottomNavigation extends StatefulWidget {
  final String user;
  const UserBottomNavigation({super.key, required this.user});

  @override
  State<UserBottomNavigation> createState() => _UserBottomNavigationState();
}

class _UserBottomNavigationState extends State<UserBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff95A3B3),
      height: 65,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: widget.user,
                ),
              ),
            );
          },
          icon: const Icon(Icons.home_outlined),
          iconSize: 35,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SearchScreen(
                  user: widget.user,
                ),
              ),
            );
          },
          icon: const Icon(Icons.search),
          iconSize: 35,
        ),
        IconButton(
          onPressed: () {
           
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>  UserProfileScreen(
                    user: widget.user,
                  ),
                ),
              );
            
          },
          icon: const Icon(Icons.account_circle_outlined),
          iconSize: 35,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BookingDetail(
                  user: widget.user,
                ),
              ),
            );
          },
          icon: const Icon(Icons.history),
          iconSize: 35,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AboutUs(
                  user: widget.user,
                ),
              ),
            );
          },
          icon: const Icon(Icons.people_outline),
          iconSize: 35,
        ),
      ]),
    );
  }
}
