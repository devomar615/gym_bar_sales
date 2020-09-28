import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/models/total.dart';
import 'package:gym_bar_sales/core/models/transaction.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/locator.dart';

class TransactionModel extends BaseModel {
  Api _api = locator<Api>();
  List<Transaction> transaction;
  List<Total> total;
  Product product;

  Future addTransaction({Transaction transaction, branchName}) async {
    setState(ViewState.Busy);
    await _api.addDocument(transaction.toJson(), "transactions/branches/$branchName");
    setState(ViewState.Idle);
  }

  Future<List<Transaction>> fetchTransaction({branchName}) async {
    var result = await _api.getDataCollection("transactions/branches/$branchName/");
    transaction = result.docs.map((doc) => Transaction.fromMap(doc.data(), doc.id)).toList();
    return transaction;
  }

  Future fetchFilteredTransaction({
    branchName,
    field,
    equalTo,
    field2,
    equalTo2,
    field3,
    equalTo3,
    field4,
    equalTo4,
  }) async {
    setState(ViewState.Busy);
    var result = await _api.getCustomDataCollection(
      path: "transaction/branches/$branchName/",
      field: field,
      equalTo: equalTo,
      field2: field2,
      equalTo2: equalTo2,
      field3: field3,
      equalTo3: equalTo3,
      field4: field4,
      equalTo4: equalTo4,
    );
    transaction = result.docs.map((doc) => Transaction.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }

//  Future fetchTotal({docId}) async {
//    setState(ViewState.Busy);
//    await _api.getDocumentById('total', docId).then((ds) {
//      total = Total.fromMap(ds.data(), ds.id);
//    });
//
//    print("total cash is: ");
//    print(total.cash);
//
//    setState(ViewState.Idle);
//  }

  Future fetchTotal() async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("total");
    total = result.docs.map((doc) => Total.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
    return total;
  }

  updateTotal({docId, Map<String, dynamic> data}) async {
    await _api.updateDocument(docId, data, "total");
  }

  updateProducts({branchName, Map<String, dynamic> data, productId}) async {
    setState(ViewState.Busy);
    print('printing from method........');
    print(branchName);
    print(productId);
    print(data);
    print('Done Printingggggggg.............:D');
    await _api.updateDocument(productId, data, "products/branches/$branchName/");
    setState(ViewState.Idle);
  }

  addWithdraw() {}

  addDeposit() {}
}
