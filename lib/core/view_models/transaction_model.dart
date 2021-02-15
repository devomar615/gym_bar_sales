import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/my_transaction.dart';

class TransactionModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<MyTransaction> _transaction;

  List<MyTransaction> get transaction => _transaction;

  List<MyTransaction> _filteredTransactions;

  set filteredTransactions(List<MyTransaction> value) {
    _filteredTransactions = value;
    notifyListeners();
  }

  List<MyTransaction> get filteredTransactions => _filteredTransactions;

  Status _status = Status.Busy;

  Status get status => _status;

  List<MyTransaction> getTransactionByCustomerName(String customerName) {
    return _transaction
        .where((transaction) => transaction.customerName == customerName)
        .toList();
  }

  Future fetchTransaction({branchName}) async {
    _status = Status.Busy;
    var result =
        await _db.collection("transactions/branches/$branchName/").get();
    _transaction = result.docs
        .map((doc) => MyTransaction.fromMap(doc.data(), doc.id))
        .toList();
    _status = Status.Idle;
    notifyListeners();
  }

  Future addTransaction({MyTransaction transaction, branchName}) async {
    _status = Status.Busy;
    _db
        .collection("transactions/branches/$branchName")
        .add(transaction.toJson());
    _status = Status.Idle;
    notifyListeners();
  }

  Future fetchTransactionByCustomerName({branchName, customerName}) async {
    _status = Status.Busy;
    var result = await _db
        .collection("transactions/branches/$branchName/")
        .where("customerName", isEqualTo: customerName)
        .get();
    _filteredTransactions = result.docs
        .map((doc) => MyTransaction.fromMap(doc.data(), doc.id))
        .toList();
    _status = Status.Idle;
    notifyListeners();
  }

// Future fetchFilteredTransaction({
//   @required branchName,
//   field,
//   equalTo,
//   field2,
//   equalTo2,
//   field3,
//   equalTo3,
//   field4,
//   equalTo4,
// }) async {
//   var result = await _api.getCustomDataCollection(
//     path: "transactions/branches/$branchName/",
//     field: field,
//     equalTo: equalTo,
//     field2: field2,
//     equalTo2: equalTo2,
//     field3: field3,
//     equalTo3: equalTo3,
//     field4: field4,
//     equalTo4: equalTo4,
//   );
//   transaction = result.docs
//       .map((doc) => Transaction.fromMap(doc.data(), doc.id))
//       .toList();
// }
//
// addWithdraw() {}
//
// addDeposit() {}
}
