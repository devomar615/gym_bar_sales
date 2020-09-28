import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_bar_sales/core/models/user.dart';

class Api {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var ref;

  Future<UserProfile> getUserProfile(userId) async {
    UserProfile user;
    if (userId != null) {
      user = await _db
          .collection('users')
          .doc(userId)
          .get()
          .then((documentSnapshot) => UserProfile.fromDocument(documentSnapshot));
    }
    return user;
  }

  Future<QuerySnapshot> getDataCollection(String path) {
    ref = _db.collection(path).get();
    return ref;
  }

  Future<QuerySnapshot> getCustomDataCollection({
    path,
    field,
    equalTo,
    field2,
    equalTo2,
    field3,
    equalTo3,
    field4,
    equalTo4,
  }) {
    if (field2 != null &&
        equalTo2 != null &&
        field3 != null &&
        equalTo3 != null &&
        field4 != null &&
        equalTo4 != null) {
      ref = _db
          .collection(path)
          .where(field, isEqualTo: equalTo)
          .where(field2, isEqualTo: equalTo2)
          .where(field3, isEqualTo: equalTo3)
          .where(field4, isEqualTo: equalTo4)
          .get();
    } else if (field2 != null &&
        equalTo2 != null &&
        field3 != null &&
        equalTo3 != null &&
        field4 == null &&
        equalTo4 == null) {
      ref = _db
          .collection(path)
          .where(field, isEqualTo: equalTo)
          .where(field2, isEqualTo: equalTo2)
          .where(field3, isEqualTo: equalTo3)
          .get();
    } else if (field2 != null &&
        equalTo2 != null &&
        field3 == null &&
        equalTo3 == null &&
        field4 == null &&
        equalTo4 == null) {
      ref = _db
          .collection(path)
          .where(field, isEqualTo: equalTo)
          .where(field2, isEqualTo: equalTo2)
          .get();
    } else if (field2 == null &&
        equalTo2 == null &&
        field3 == null &&
        equalTo3 == null &&
        field4 == null &&
        equalTo4 == null) {
      ref = _db.collection(path).where(field, isEqualTo: equalTo).get();
    }
    return ref;
  }

  Stream<QuerySnapshot> streamDataCollection(String path) {
    ref = _db.collection(path);
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String path, String id) {
    ref = _db.collection(path).doc(id).get();
    return ref;
  }

  Future<void> removeDocument(String id, String path) {
    ref = _db.collection(path);
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data, String path) {
    ref = _db.collection(path);
    return ref.add(data);
  }

  Future<DocumentReference> addDocumentCustomId(docID, Map data, String path) {
    ref = _db.collection(path);
    return ref.document(docID).setData(data);
  }

  Future<void> updateDocument(
    id,
    Map<String, dynamic> data,
    String path,
  ) {
    ref = _db.collection(path);
    return ref.document(id).updateData(data);
  }

  static Future<bool> checkDocExist(path, String userId) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("$path/$userId").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }
}
