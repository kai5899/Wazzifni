import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locateme/Models/JobOffer.dart';
import 'package:locateme/Models/ServiceProvider.dart';
import 'package:locateme/Models/UserModel.dart';

class FirestoreService {
  FirebaseFirestore _database = FirebaseFirestore.instance;

  createRegularUser(UserModel userModel) {
    try {
      _database.collection("users").doc(userModel.uid).set(userModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  createServiceProvider(ServiceProvider userModel) {
    try {
      _database.collection("users").doc(userModel.uid).set(userModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  postOffer(JobOffer newOffer) {
    try {
      _database
          .collection("offers")
          .doc(newOffer.id.toString())
          .set(newOffer.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    try {
      DocumentSnapshot doc = await _database.collection("users").doc(id).get();

      return doc.data();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> updateUser(String userID, Map<String, dynamic> map) async {
    try {
      await _database.collection("users").doc(userID).update(map);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<DocumentSnapshot>> getServicesProviders() async {
    QuerySnapshot _data = await _database
        .collection("users")
        .where("type", isEqualTo: "Service Provider")
        .get();

    return _data.docs;
  }

  Future<List<DocumentSnapshot>> getOffers() async {
    QuerySnapshot _data = await _database
        .collection("offers")
        .orderBy("id", descending: true)
        .get();

    return _data.docs;
  }
}
