import 'package:flutter/cupertino.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';

class TotalModel extends ChangeNotifier {
  Api _api;

  List<Total> total;
  Total oneTotal;

  Future fetchTotal({docId}) async {
    var doc = await _api.getDocumentById('total', docId);
    oneTotal = Total.fromMap(doc.data(), doc.id);
    return total;
  }

  updateTotal({docId, Total total}) async {
    Api.checkDocExist("total", docId).then((value) async {
      if (!value) {
        await _api.addDocumentCustomId(docId, total.toJson(), "total");
      }
      if (value) {
        await _api.updateDocument(docId, total.toJson(), "total");
      }
    });
  }
}
