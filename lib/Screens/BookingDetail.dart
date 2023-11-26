import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pg/componets/UserBottomNavigation.dart';
import 'package:pg/componets/reuseWidgets.dart';

class BookingDetail extends StatefulWidget {
  final String user;
  const BookingDetail({super.key, required this.user});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  final CollectionReference _data =
      FirebaseFirestore.instance.collection('Booking_details');

  @override
  void initState() {
    super.initState();
    if (widget.user == "null") {
      Future.delayed(Duration(microseconds: 500), () {
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: reuseSnackBarMessageText(Message: "Login First!!")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
        leading: const Padding(
          //padding:EdgeInsets.all(8.0),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
        ),
      ),
      body: StreamBuilder(
          stream: _data.where("UserEmail", isEqualTo: widget.user).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    Color displayColor = Colors.yellow;
                    if (documentSnapshot['Status'] == "Pending") {
                      displayColor = Colors.orange;
                    } else if (documentSnapshot['Status'] == "Cancel") {
                      displayColor = Colors.red;
                    } else {
                      displayColor = Colors.green;
                    }

                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        margin: const EdgeInsets.fromLTRB(15, 5, 15, 9),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.home_outlined,
                                              size: 30,
                                              color: Color(0xff0A1045)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            documentSnapshot['PGName'],
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: Color(0xff0A1045)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            documentSnapshot['City'],
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: Color(0xff0A1045),
                                            ),
                                          ),
                                          Text(
                                            "₹ ${documentSnapshot['Amount']}",
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Booked On :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${documentSnapshot['BookedOn']}",
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xff0A1045),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Status : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            documentSnapshot['Status'],
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: displayColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ));
                  });
            }
           
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      bottomNavigationBar: UserBottomNavigation(user: widget.user),
    );
  }
}
