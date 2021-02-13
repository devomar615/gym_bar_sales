import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/client.dart';

class ClientModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool nameAscending = false;
  bool cashAscending = false;

  Status _status = Status.Busy;

  Status get status => _status;

  List<Client> _client;
  Client _selectedClient;

  String _selectedClientType = 'all';

  String get selectedClientType => _selectedClientType;

  set selectedClientType(String value) {
    _selectedClientType = value;
    notifyListeners();
  }

  set selectedClient(Client selectedClient) {
    _selectedClient = selectedClient;
    notifyListeners();
  }

  List<Client> get clients => _client;

  Client get selectedClient => _selectedClient;

  changeNameAscendingState() {
    nameAscending = !nameAscending;
    notifyListeners();
  }

  changeCashAscendingState() {
    cashAscending = !cashAscending;
    notifyListeners();
  }

  List<Client> filterClients(String selectedClientType) {
    if (selectedClientType == "all") {
      return _client;
    } else
      return _client
          .where((client) => client.type == selectedClientType)
          .toList();
  }

  Future fetchClients({branchName}) async {
    _status = Status.Busy;
    var result = await _db.collection("clients/branches/$branchName/").get();
    _client =
        result.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
    _status = Status.Idle;
    notifyListeners();
  }

  Future updateClient(
      {clientId, Map<String, dynamic> data, String branchName}) async {
    _status = Status.Busy;

    await _db
        .collection("clients/branches/$branchName/")
        .doc(clientId)
        .update(data);
    _status = Status.Idle;
    notifyListeners();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:gym_bar_sales/core/models/client.dart';
// import 'package:gym_bar_sales/core/models/employee.dart';
// import 'package:gym_bar_sales/core/view_models/base_model.dart';
// import 'package:gym_bar_sales/core/services/api.dart';
//
// class ClientModel extends ChangeNotifier {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   List<Client> _client;
//   Client _selectedClient;
//   Client _selectedClientForMore = Client();
//
//   Client get selectedClientForMore => _selectedClientForMore;
//
//   set selectedClientForMore(Client value) {
//     _selectedClientForMore = value;
//     notifyListeners();
//   }
//
//   String _selectedClientType = 'All';
//   bool nameAscending = false;
//   bool cashAscending = false;
//
//   String get selectedClientType => _selectedClientType;
//
//   set selectedClientType(String value) {
//     _selectedClientType = value;
//     notifyListeners();
//   }
//
//   Client get selectedClient => _selectedClient;
//
//   set selectedClient(Client selectedClient) {
//     _selectedClient = selectedClient;
//     notifyListeners();
//   }
//
//
//   List<Client> get clients => _client;
//
//   List<Client> filterClients(String selectedEmployeeType) {
//     if (selectedEmployeeType == "All") {
//       return _client;
//     } else
//       return _client
//           .where((product) => product.category == selectedEmployeeType)
//           .toList();
//   }
//
//   changeNameAscendingState() {
//     nameAscending = !nameAscending;
//     notifyListeners();
//   }
//
//   changeCashAscendingState() {
//     cashAscending = !cashAscending;
//     notifyListeners();
//   }
//
//   Future fetchClients({branchName}) async {
//     var result = await _db.collection("clients/branches/$branchName/").get();
//     _client =
//         result.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
//     notifyListeners();
//   }
// }
