import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/employee.dart';

import '../enums.dart';

class EmployeeModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Employee> _employees;
  Employee _selectedEmployee;
  Status _status = Status.Busy;

  Status get status => _status;

  set selectedEmployee(Employee selectedEmployee) {
    _selectedEmployee = selectedEmployee;
    notifyListeners();
  }

  List<Employee> get employees => _employees;

  Employee get selectedEmployee => _selectedEmployee;

  Future fetchEmployees({branchName}) async {
    _status = Status.Busy;

    var result = await _db.collection("employees/branches/$branchName/").get();
    _employees =
        result.docs.map((doc) => Employee.fromMap(doc.data(), doc.id)).toList();

    _status = Status.Idle;
    notifyListeners();
  }

  Future updateEmployee(
      {employeeId, Map<String, dynamic> data, String branchName}) async {
    _status = Status.Busy;
    await _db
        .collection("employees/branches/$branchName/")
        .doc(employeeId)
        .update(data);
    _status = Status.Idle;
  }
}
