import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/services/api.dart';

class EmployeeModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Employee> _employees;
  Employee _selectedEmployee;

  set selectedEmployee(Employee selectedEmployee) {
    _selectedEmployee = selectedEmployee;
    notifyListeners();
  }

  List<Employee> get employees => _employees;

  Employee get selectedEmployee => _selectedEmployee;

  Future fetchEmployees({branchName}) async {
    var result = await _db.collection("employees/branches/$branchName/").get();
    _employees =
        result.docs.map((doc) => Employee.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Future updateEmployee(
      {employeeId, Map<String, dynamic> data, String branchName}) async {
    await _db
        .collection("employees/branches/$branchName/")
        .doc(employeeId)
        .update(data);
  }
}
