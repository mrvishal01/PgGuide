import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Backend {
  CollectionReference _manageUser =
      FirebaseFirestore.instance.collection("manageUser");
  CollectionReference _pgDetails =
      FirebaseFirestore.instance.collection("PG_details");
  CollectionReference _bookingDetail =
      FirebaseFirestore.instance.collection("Booking_details");
  Future<void> AddBookingDetail({
    required String PGName,
    required String City,
    required String Amount,
    required String UserEmail,
    required String OwnerEmail,
  }) async {
    String Bookeddate = DateFormat("dd MMM yyyy").format(DateTime.now());
    final data = {
      "PGName": PGName,
      "City": City,
      "Amount": Amount,
      "Status": "Pending",
      "Rooms": "1",
      "UserEmail": UserEmail,
      "OwnerEmail": OwnerEmail,
      "BookedOn": Bookeddate
    };

    await _bookingDetail.add(data);
  }

  Future<void> UpdatePGBookingStatus(
      {required String Status, required String id}) async {
    if (Status == "Booked") {
      _bookingDetail.doc(id).update({"Status": Status});
    } else {
      _bookingDetail.doc(id).update({"Status": Status});

    }
  }

  Future<void> signup(
      {required String unm,
      required String email,
      required String pwd,
      required String cnfPassword,
      required String role}) async {
    if (role == "User") {
      final data = {
        "Email": email,
        "Username": unm,
        "Password": pwd,
        "ConfirmPassword": cnfPassword,
        "Role": role,
        "InstaLink": "Not Given"
      };
      await _manageUser.add(data);
    } else {
      final data = {
        "Email": email,
        "Username": unm,
        "Password": pwd,
        "ConfirmPassword": cnfPassword,
        "Role": role,
        "InstaLink": "Not Given",
        "ContactNo": "To be Updated"
      };
      await _manageUser.add(data);
    }
  }

  Future<void> AddPGData(
      {required String area,
      required String city,
      required String description,
      required String facilities,
      required String houseNo,
      required String imageUrl,
      required String pgName,
      required String pgType,
      required String pincode,
      required String owner,
      required String price,
      required String room}) async {
    final data = {
      "PGName": pgName,
      "HouseNo": houseNo,
      "City": city,
      "Pincode": pincode,
      "Facilities": facilities,
      "PGType": pgType,
      "Description": description,
      "imageUrl": imageUrl,
      "Owner": owner,
      "Price": price,
      "Area": area,
      "InstaLink": "Not Available",
      "Contact": "To be updated",
      "Rooms": room
    };
    await _pgDetails.add(data);
  }

  Future<void> UpdateUserProfile(
      {required String ChangePassword,
      required String InstaLink,
      required String id}) async {
    {
      final data = {
        "InstaLink": InstaLink,
        "Password": ChangePassword,
        "ConfirmPassword": ChangePassword
      };
      await _manageUser.doc(id).update(data);
    }
  }

  Future<void> UpdateAdminProfile(
      {required String ChangePassword,
      required String InstaLink,
      required String Contact,
      required String Email,
      required String id}) async {
    final data = {
      "InstaLink": InstaLink,
      "Password": ChangePassword,
      "ConfirmPassword": ChangePassword,
      "ContactNo": Contact
    };
    await _manageUser.doc(id).update(data);
  }

  Future<void> UpdatePGData(
      {required String id, required String deduction}) async {
    await _pgDetails.doc(id).update({"Rooms": deduction});
  }

  Future<void> deletePG(String productId) async {
    await _pgDetails.doc(productId).delete();
  }
}
