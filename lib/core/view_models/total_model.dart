import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/services/api.dart';

class TotalModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Status _status = Status.Busy;

  Status get status => _status;

  List<Total> total;

  Future fetchTotal() async {
    _status = Status.Busy;

    var result = await _db.collection("total").get();
    total =
        result.docs.map((doc) => Total.fromMap(doc.data(), doc.id)).toList();
    _status = Status.Idle;

    notifyListeners();
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
    _status = Status.Busy;
    await _db.collection("total").doc(docId).update(data);
    _status = Status.Idle;
  }
}
