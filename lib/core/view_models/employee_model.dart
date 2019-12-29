import 'package:gym_bar_sales/core/enums/viewstate.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';

import '../../locator.dart';

class EmployeeModel extends BaseModel {
  Api _api = locator<Api>();

  List<Employee> employees;

//  Future<List<Employee>> fetchAttendance(String path) async {
//    setState(ViewState.Busy);
//    var result = await _api.getDataCollection(path);
//    employees = result.documents
//        .map((doc) => Employee.fromMap(doc.data, doc.documentID))
//        .toList();
//    setState(ViewState.Idle);
//    return employees;
//  }

  Future fetchEmployees() async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("employees");
    employees = result.documents
        .map((doc) => Employee.fromMap(doc.data, doc.documentID))
        .toList();
    setState(ViewState.Idle);
  }
}
