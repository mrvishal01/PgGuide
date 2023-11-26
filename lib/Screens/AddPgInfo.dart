import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pg/Screens/OwnerHomeScreen.dart';
import 'package:pg/componets/Backend.dart';
import 'package:pg/componets/OwnerBottomNavigation.dart';
import 'package:pg/componets/reuseWidgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddPgInfo extends StatefulWidget {
  final String admin;
  const AddPgInfo({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<AddPgInfo> createState() => _AddPgInfoState();
}

class _AddPgInfoState extends State<AddPgInfo> {
  final TextEditingController pgName = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController homeNo = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController room = TextEditingController();
  String? ImageLink;

  final List<String> items = [
    'AC',
    'Non-AC',
  ];
  String? facilitiesValue;
  final List<String> itemsGender = [
    'Boys PG',
    'Girls PG',
  ];
  String? genderValue;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadImage() async {
    final path = 'images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() => {});

    final imageUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      ImageLink = imageUrl;
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe5e6e4),
      appBar: AppBar(
        title: const Text("Add PG"),
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
              
              const SizedBox(height: 10),
              resueTextField(
                text: "HouseNo - Society Name",
                icon: Icons.home,
                isPasswordType: false,
                controller: homeNo,
                size: screenWidth,
              ),
              const SizedBox(height: 10),
              resueTextField(
                  text: "Area, Colony",
                  icon: Icons.pin_drop,
                  isPasswordType: false,
                  controller: area,
                  size: screenWidth),

              //State to be added further
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
              const SizedBox(height: 20),
              Container(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Facilities',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: facilitiesValue,style: TextStyle(fontFamily: 'Montserrat',color: Colors.black),
                        onChanged: (String? value) {
                          setState(() {
                            facilitiesValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'PG Type',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: itemsGender
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: genderValue,style: TextStyle(fontFamily: 'Montserrat',color: Colors.black),
                        onChanged: (String? value) {
                          setState(() {
                            genderValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              reuseFacilitiesContainer(
                  hintText: "PG Facilities", textarea: description),
              const SizedBox(height: 5),
              Column(children: [
                if (pickedFile != null)
                  Container(
                    height: 240,
                    color: Colors.blue[100],
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                buildProgress(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: selectImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0A1045),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Select Image",
                        style: TextStyle(
                            color: Color(0xffe5e6e4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: uploadImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0A1045),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(
                            color: Color(0xffe5e6e4),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    if (pgName.text == "" ||
                        homeNo.text == "" ||
                        area.text == "" ||
                        city.text == "" ||
                        pincode.text == "" ||
                        description.text == "" ||
                        room.text == "" ||
                        price.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: reuseSnackBarMessageText(Message: "Please Entered All Filed!!"),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ));
                    } else {
                      Backend b = Backend();

                      b.AddPGData(
                          pgName: pgName.text,
                          houseNo: homeNo.text,
                          area: area.text,
                          city: city.text,
                          pincode: pincode.text,
                          description: description.text,
                          facilities: facilitiesValue!,
                          pgType: genderValue!,
                          imageUrl: ImageLink!,
                          price: price.text,
                          owner: widget.admin,
                          room: room.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('PG Added Successfully \nPlease Update profile for contact'),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => OwnerHomeScreen(
                                  admin: widget.admin,
                                ),
                              ),
                            );
                          },
                        ),
                      ));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OwnerHomeScreen(
                          admin: widget.admin,
                        ),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0A1045),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add PG",
                    style: TextStyle(
                        color: Color(0xffe5e6e4),
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
      bottomNavigationBar: OwnerBottomNavigationBar(
        admin: widget.admin,
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(height: 50);
          }
        }),
      );
}
