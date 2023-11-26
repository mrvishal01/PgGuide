import 'package:flutter/material.dart';
import 'package:pg/componets/reuseWidgets.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffE5E6E4),
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Container(
            width:screenWidth,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [reuseImage(),],),
              const Text(
                'Welcome To PG Guide...!', style: TextStyle(fontFamily: 'Montserrat',fontSize: 25, fontWeight: FontWeight.w400),),
              const SizedBox(height: 20),
              const Text(
                'It\'s Time to Book Your Sweet Home',
                style: TextStyle(fontFamily: 'Montserrat',fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(height: 180),

            reuseOutlinedButton(text:'Sign Up as a Owner',context: context, path:'/signup', height:45),
              const SizedBox(height: 10),
              reuseOutlinedButton(text:'  Sign Up as a User  ', context:context, path:'/signup', height:45),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const  Text(
                    "Already have an account?",
                    style: TextStyle(fontFamily: 'Montserrat',fontSize: 16),
                  ),
                  link(text:"Sign In",context: context, path: '/login')
                ],
              )

            ]),
          ),
        ),
      ),
    );
  }
}
