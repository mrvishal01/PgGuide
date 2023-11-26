import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pg/componets/Backend.dart';
import 'package:pg/componets/OwnerBottomNavigation.dart';

class OwnerBookedDetail extends StatefulWidget {
  final String admin;
  const OwnerBookedDetail({Key? key, required this.admin}) : super(key: key);

  @override
  State<OwnerBookedDetail> createState() => _OwnerBookedDetailState();
}

class _OwnerBookedDetailState extends State<OwnerBookedDetail> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('Booking_details');
  String Status = "";
  String ClickStatus = "Pending";
  Color displayColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Booked Detail",
          
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Status:'),
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                           
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  child: Text("Pending"),
                                  onPressed: () {
                                    setState(() {
                                      ClickStatus = "Pending";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    setState(() {
                                      ClickStatus = "Cancel";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Booked"),
                                  onPressed: () {
                                    setState(() {
                                      ClickStatus = "Booked";
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ]));
                    });
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: StreamBuilder(
          stream: _firestore
              .where("OwnerEmail", isEqualTo: widget.admin)
              .where("Status", isEqualTo: ClickStatus)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  if (documentSnapshot['Status'] == "Pending") {
                    displayColor = Colors.orange;
                  } else if (documentSnapshot['Status'] == "Cancel") {
                    displayColor = Colors.red;
                  } else {
                    displayColor = Colors.green;
                  }
                  print("Length : ${streamSnapshot.data!.docs.length}");
                  if (streamSnapshot.data!.docs.length == 0) {
                    return Center(child: Text("Sorry No Data Found"));
                  }
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 5, 15, 9),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff0A1045)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(Icons.person_outline,
                                                      size: 25,
                                                      color: Color(0xff0A1045)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    documentSnapshot[
                                                        'UserEmail'],
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18,
                                                            color: Color(
                                                                0xff0A1045)),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    documentSnapshot['City'],
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                      color: Color(0xff0A1045),
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ ${documentSnapshot['Amount']}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 7),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Rooms :",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${documentSnapshot['Rooms']}",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff0A1045),
                                                      ),
                                                    ),
                                                    SizedBox(width: 50),
                                                    Text(
                                                      "Status : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      documentSnapshot[
                                                          'Status'],
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 15,
                                                              color:
                                                                  displayColor),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Status = "Booked";
                                                      Backend b = Backend();
                                                      b.UpdatePGBookingStatus(
                                                          Status: Status,
                                                          id: documentSnapshot
                                                              .id);
                                                      setState(() {
                                                        displayColor =
                                                            Colors.green;
                                                      });
                                                      print(
                                                          documentSnapshot.id);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xff84DCC6),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Approve',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff222222),
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Status = "Cancel";
                                                      Backend b = Backend();
                                                      b.UpdatePGBookingStatus(
                                                          Status: Status,
                                                          id: documentSnapshot
                                                              .id);
                                                      setState(() {
                                                        displayColor =
                                                            Colors.red;
                                                      });
                                                      print(
                                                          documentSnapshot.id);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xff84DCC6),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff222222),
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
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
                                ))
                          ])));
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      bottomNavigationBar: OwnerBottomNavigationBar(admin: widget.admin),
    );
  }
}
