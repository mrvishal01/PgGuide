import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pg/componets/reuseWidgets.dart';

class EditPgInfo extends StatefulWidget {
  final String admin;
  final String pgId;

  const EditPgInfo({Key? key, required this.admin, required this.pgId})
      : super(key: key);

  @override
  _EditPgInfoState createState() => _EditPgInfoState();
}

class _EditPgInfoState extends State<EditPgInfo> {
  final TextEditingController pgName = TextEditingController();
  final TextEditingController homeNo = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController room = TextEditingController();
  final TextEditingController description = TextEditingController();

  String? facilitiesValue;
  final List<String> facilities = ['AC', 'Non-AC'];

  String? pgTypeValue;
  final List<String> pgTypes = ['Boys PG', 'Girls PG'];

  @override
  void initState() {
    super.initState();
    fetchPgDetails();
  }

  Future<void> fetchPgDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('PG_details')
          .doc(widget.pgId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          pgName.text = documentSnapshot['PGName'];
          homeNo.text = documentSnapshot['HouseNo'];
          area.text = documentSnapshot['Area'];
          city.text = documentSnapshot['City'];
          pincode.text = documentSnapshot['Pincode'];
          price.text = documentSnapshot['Price'];
          room.text = documentSnapshot['Rooms'];
          facilitiesValue = documentSnapshot['Facilities'];
          pgTypeValue = documentSnapshot['PGType'];
          description.text = documentSnapshot['Description'];
        });
      }
    } catch (e) {
      print("Error fetching PG details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit PG Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Container(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                resueTextField(
                  text: "PG Name",
                  icon: Icons.add_business,
                  isPasswordType: false,
                  controller: pgName,
                  size: screenWidth,
                ),
                
                const SizedBox(height: 4),
                resueTextField(
                  text: "HouseNo - Society Name",
                  icon: Icons.home,
                  isPasswordType: false,
                  controller: homeNo,
                  size: screenWidth,
                ),
                const SizedBox(height: 6),
                resueTextField(
                    text: "Area, Colony",
                    icon: Icons.pin_drop,
                    isPasswordType: false,
                    controller: area,
                    size: screenWidth),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    resueTextField(
                        text: "City",
                        icon: Icons.location_city,
                        isPasswordType: false,
                        controller: city,
                        size: 150),
                    resueTextField(
                        text: "Pincode",
                        icon: Icons.pin,
                        isPasswordType: false,
                        controller: pincode,
                        size: 150),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    resueTextField(
                        text: "Price",
                        icon: Icons.currency_rupee,
                        isPasswordType: false,
                        controller: price,
                        size: 150),
                    resueTextField(
                        text: "No. of Rooms",
                        icon: Icons.home,
                        isPasswordType: false,
                        controller: room,
                        size: 150),
                  ],
                ),
                const SizedBox(
                  height: 13
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: facilitiesValue,style: TextStyle(fontFamily: 'Montserrat',color: Colors.black),
                      onChanged: (String? value) {
                        setState(() {
                          facilitiesValue = value;
                        });
                      },
                      items: facilities.map((String facility) {
                        return DropdownMenuItem<String>(
                          value: facility,
                          child: Text(facility),
                        );
                      }).toList(),
                      hint: const Text('Select Facilities',style: TextStyle(fontFamily: 'Montserrat'),),
                    ),
                    DropdownButton<String>(
                      value: pgTypeValue,style: TextStyle(fontFamily: 'Montserrat',color: Colors.black),
                      onChanged: (String? value) {
                        setState(() {
                          pgTypeValue = value;
                        });
                      },
                      items: pgTypes.map((String pgType) {
                        return DropdownMenuItem<String>(
                          value: pgType,
                          child: Text(pgType),
                        );
                      }).toList(),
                      hint: const Text('Select PG Type',style: TextStyle(fontFamily: 'Montserrat'),),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                reuseFacilitiesContainer(
                    hintText: "PG Facilities",
                    textarea: description,
                    ),
                ElevatedButton(
                  onPressed: () {
                    updatePgDetails();
                  },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0A1045),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                  child: const Text("Update PG",style: TextStyle(
                            color: Color(0xffe5e6e4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updatePgDetails() async {
    try {
      String updatedPgName = pgName.text;
      String updatedHouseNo = homeNo.text;
      String updatedArea = area.text;
      String updatedCity = city.text;
      String updatedPincode = pincode.text;
      String updatedPrice = price.text;
      String updatedRooms = room.text;
       String updateDescription = description.text;

      await FirebaseFirestore.instance
          .collection('PG_details')
          .doc(widget.pgId)
          .update({
        'PGName': updatedPgName,
        'HouseNo': updatedHouseNo,
        'Area': updatedArea,
        'City': updatedCity,
        'Pincode': updatedPincode,
        'Price': updatedPrice,
        'Rooms': updatedRooms,
        'Facilities': facilitiesValue,
        'PGType': pgTypeValue,
        'Description': updateDescription
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: reuseSnackBarMessageText(Message: "PG Data Updated Successfully!!"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: reuseSnackBarMessageText(Message: "PG Data Something went Wrong"),
        ),
      );
    }
  }
}
