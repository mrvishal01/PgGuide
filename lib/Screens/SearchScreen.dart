import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pg/Screens/CardScreen.dart';
import 'package:pg/componets/UserBottomNavigation.dart';

class SearchScreen extends StatefulWidget {
  final String user;

  const SearchScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";
  List<Map<String, dynamic>> data = [];
  String facilitiesFilter = "Non-AC";
  String pgTypeFilter = "Boys PG";
  TextEditingController inputText = TextEditingController();
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('PG_details');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            style: TextStyle(fontFamily: 'Montserrat',color: Colors.black),
            controller: inputText,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Enter city to search',
            ),
            onChanged: (val) {
              setState(() {
                String firstChar = val.substring(0, 1);
                String elseString = val.substring(1, val.length);
                name = firstChar.toUpperCase() + elseString.toLowerCase();
              });
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 28),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .where('City', isEqualTo: name.trim())
            .where("Facilities", isEqualTo: facilitiesFilter)
            .where("PGType", isEqualTo: pgTypeFilter)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;

                          return _buildCard(data);
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
      bottomNavigationBar: UserBottomNavigation(
        user: widget.user,
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardScreen(
              data: data['PGName'],
              price: data['Price'],
              user: widget.user,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 9),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Image.network(
                data['imageUrl'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['PGName'],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          data['Price'],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data['City'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['PGType'],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          data['Facilities'],
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
         return AlertDialog(
            title: const Text('Filters',style: TextStyle(fontFamily: 'Montserrat',)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Facilities:',style: TextStyle(fontFamily: 'Montserrat',)),
                Row(
                  children: [
                    Radio(
                      onChanged: (value) {
                        facilitiesFilter = "AC";
                        print(value.toString());
                      },
                      groupValue: facilitiesFilter,
                      value: "AC",
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("AC",style: TextStyle(fontFamily: 'Montserrat',)),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      onChanged: (value) {
                        facilitiesFilter = "Non-AC";
                      },
                      groupValue: facilitiesFilter,
                      value: "Non-AC",
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Non Ac',style: TextStyle(fontFamily: 'Montserrat',)),
                  ],
                ),
                SizedBox(height: 10),
                Text('PG Type:',style: TextStyle(fontFamily: 'Montserrat',)),
                Row(
                  children: [
                    Radio(
                      onChanged: (value) {
                        pgTypeFilter = "Boys PG";
                        setState(() {
                          
                    facilitiesFilter = facilitiesFilter.toString();
                    pgTypeFilter = pgTypeFilter.toString();
                  
                        });
                        print(value.toString());
                      },
                      groupValue: pgTypeFilter,
                      value: "Boys PG",
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Boys PG",style: TextStyle(fontFamily: 'Montserrat',)),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      onChanged: (value) {
                        pgTypeFilter = "Girls PG";
                      },
                      groupValue: pgTypeFilter,
                      value: "Girls PG",
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Girls PG',style: TextStyle(fontFamily: 'Montserrat',)),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel',style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    facilitiesFilter = facilitiesFilter.toString();
                    pgTypeFilter = pgTypeFilter.toString();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Apply',style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
  }
}
