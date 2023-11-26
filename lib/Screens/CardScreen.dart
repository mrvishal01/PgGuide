import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pg/Screens/BookingDetail.dart';
import 'package:pg/componets/Backend.dart';
import 'package:pg/componets/reuseWidgets.dart';
import 'HomeScreen.dart';

class CardScreen extends StatefulWidget {
  final String data;
  final String price;
  final String user;
  const CardScreen(
      {super.key, required this.data, required this.price, required this.user});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  String OwnerEmail = "";
  String OwnerContact = "";
  String OwnerInstaLink = "";
  String CityName = "";
  final CollectionReference _data =
      FirebaseFirestore.instance.collection('PG_details');

  void initState() {
    super.initState();
    debugPrint(widget.data);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('PG_details')
          .where("PGName", isEqualTo: widget.data)
          .get()
          .then((value) {
        for (var element in value.docs) {
          OwnerEmail = element.data()['Owner'];
          print(OwnerEmail);
        }
        setState(() {});
      });
    });
  }

  Map<String, dynamic>? paymentIntent;
  int paymentSuccessful = 1;
  String id = "";
  String room = "";

  void makePayment() async {
    try {
      print('CALL');
      paymentIntent = await createPaymentIntent();
      print('payment intent --> $paymentIntent');
      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "IN", currencyCode: "inr", testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.light,
        merchantDisplayName: 'Kishan Yadav',
        googlePay: gpay,
      ));
      displayPaymentSheet();
    } catch (e) {
      print(e);
      Backend b = Backend();
      b.UpdatePGData(id: id, deduction: (int.parse(room) + 1).toString());
    }
  }

  void displayPaymentSheet() async {
    print("Called...");
    try {
      Backend b = Backend();
      Stripe.instance.presentPaymentSheet().then((value) => {
            b.UpdatePGData(id: id, deduction: (int.parse(room) - 1).toString()),
            b.AddBookingDetail(
                PGName: widget.data,
                City: CityName,
                Amount: widget.price,
                UserEmail: widget.user,
                OwnerEmail: OwnerEmail),
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Payment Successful!",style: TextStyle(fontFamily: 'Montserrat',fontSize: 15,fontWeight: FontWeight.bold)),
              action: SnackBarAction(
                label: "OK",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetail(
                        user: widget.user,
                      ),
                    ),
                  );
                },
              ),
            ))
          });
      paymentSuccessful = 0;
      print("Payment Successfully");
    } catch (e) {
      print('Failed');
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        'amount': '${widget.price}00',
        'currency': "inr",
      };

      http.Response response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51O258fSAYwVWBfMKLhly95eLxb5lRxrEpaHuXKALfj0fJb1y9vS2HNtMvJeXpIVNjdbIpu50ba2FS8ZAMOwT04l400dopGKN4H',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore
          .collection('manageUser')
          .where("Email", isEqualTo: OwnerEmail.toString())
          .get()
          .then((value) {
        for (var element in value.docs) {
          OwnerContact = element.data()['ContactNo'];
          OwnerInstaLink = element.data()['InstaLink'];
        }
        setState(() {});
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PG Detail',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _data.where("PGName", isEqualTo: widget.data).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                print(documentSnapshot['Price']);
                id = documentSnapshot.id;
                room = documentSnapshot['Rooms'];
                CityName = documentSnapshot['City'];

                return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child:
                                  Image.network(documentSnapshot['imageUrl'])),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "PG Name : ${documentSnapshot['PGName']}",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Color(0xff0A1045)),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "Address : ",
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                          "${documentSnapshot['HouseNo']}, ${documentSnapshot['Area']}, ${documentSnapshot["City"]}  ${documentSnapshot['Pincode']}",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                      SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "PG Type :- ${documentSnapshot['PGType']}",
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18)),
                                          Text(
                                            documentSnapshot['Facilities'],
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Color(0xff0A1045)),
                                          ),
                                          SizedBox()
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                          "Available Rooms :  ${documentSnapshot['Rooms']}",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Amenities",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Color(0xff0A1045))),
                                      Text("${documentSnapshot['Description']}",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                    ],
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                          "Email : ${documentSnapshot['Owner']}",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text("Contact No : ${OwnerContact}",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text("Social Media : ${OwnerInstaLink}",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18))
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price :  ₹${widget.price}",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xff0A1045)),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.user == "null") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        reuseSnackBarMessageText(
                            Message: "Please Login First!!"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(user: widget.user),
                                  ));
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )));
                  } else {
                    if (int.parse(room) == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: reuseSnackBarMessageText(
                              Message: "Sorry! PG is Full")));
                    } else {
                      makePayment();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0A1045),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Book Now",
                  style: TextStyle(
                      color: Color(0xffe5e6e4),
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
