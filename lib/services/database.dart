import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monumentbookingapp/pages/booking.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addEvent(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Event")
        .doc(id)
        .set(userInfoMap);
  }

  Stream<QuerySnapshot> getallEvents() {
    return FirebaseFirestore.instance.collection("Event").snapshots();
  }

  Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .add(userInfoMap);
  }

  Future addAdminTickets(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Tickets")
        .add(userInfoMap);
  }

  Stream<QuerySnapshot> getbookings(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .snapshots();
  }

  Stream<QuerySnapshot> getEventCategories(String category) {
    return FirebaseFirestore.instance
        .collection("Event")
        .where("Category", isEqualTo: category)
        .snapshots();
  }

  Stream<QuerySnapshot> getTickets() {
    return FirebaseFirestore.instance.collection("Tickets").snapshots();
  }

  // Scavenger Hunt Methods
  Future addScavengerHunt(Map<String, dynamic> huntMap) async {
    return await FirebaseFirestore.instance
        .collection("ScavengerHunts")
        .add(huntMap);
  }

  Stream<QuerySnapshot> getScavengerHunts() {
    return FirebaseFirestore.instance.collection("ScavengerHunts").snapshots();
  }
}
