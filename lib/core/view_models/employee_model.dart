import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/services/api.dart';

import '../locator.dart';

class EmployeeModel extends BaseModel {
  Api _api = locator<Api>();

  List<Employee> employees;

  Future fetchEmployees({branchName}) async {
    setState(ViewState.Busy);
    var result =
        await _api.getDataCollection("employees/branches/$branchName/");
    employees = result.docs
        .map((doc) => Employee.fromMap(doc.data(), doc.id))
        .toList();
    setState(ViewState.Idle);
  }

  Future fetchFilteredEmployees({
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
      path: "employees/branches/$branchName/",
      field: field,
      equalTo: equalTo,
      field2: field2,
      equalTo2: equalTo2,
      field3: field3,
      equalTo3: equalTo3,
      field4: field4,
      equalTo4: equalTo4,
    );
    employees = result.docs
        .map((doc) => Employee.fromMap(doc.data(), doc.id))
        .toList();
    setState(ViewState.Idle);
  }
}
