import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';

class TotalModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Total> total;

  Future fetchTotal() async {
    var result = await _db.collection("total").get();
    total = result.docs.map((doc) => Total.fromMap(doc.data(), doc.id)).toList();
    return total;
  }

  // updateTotal({docId, Total total}) async {
  //   Api.checkDocExist("total", docId).then((value) async {
  //     if (!value) {
  //       await _api.addDocumentCustomId(docId, total.toJson(), "total");
  //     }
  //     if (value) {
  //       await _api.updateDocument(docId, total.toJson(), "total");
  //     }
  //   });
  // }

  Future updateTotal({docId, Map<String, dynamic> data}) async {
    await _db.collection("total").doc(docId).update(data);
  }
}
