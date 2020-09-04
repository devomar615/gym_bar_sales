import 'package:gym_bar_sales/core/locator.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/services/api.dart';

class EmployeeClientModel extends BaseModel {
  Api _api = locator<Api>();

  List<Client> clients;
  List<Employee> employees;

  Future addClient({Client client, String branchName}) async {
    setState(ViewState.Busy);
    await _api.addDocument(client.toJson(), "clients/branches/$branchName/");
    setState(ViewState.Idle);
  }

  Future addEmployee({Employee employee, String branchName}) async {
    setState(ViewState.Busy);
    await _api.addDocument(employee.toJson(), "employees/branches/$branchName/");
    setState(ViewState.Idle);
  }

  Future fetchClients(branchName) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("clients/branches/$branchName/");
    clients = result.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }

  Future fetchEmployees({branchName}) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("employees/branches/$branchName/");
    employees = result.docs.map((doc) => Employee.fromMap(doc.data(), doc.id)).toList();
    print("employee first name is: ${employees[1].name}");
    setState(ViewState.Idle);
  }

  fetchClientsAndEmployees({branchName}) async {
    setState(ViewState.Busy);
    var clientResult = await _api.getDataCollection("clients/branches/$branchName/");
    clients = clientResult.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
    var employeeResult = await _api.getDataCollection("employees/branches/$branchName/");
    employees = employeeResult.docs.map((doc) => Employee.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }

  Future fetchFilteredClients({
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
      path: "clients/branches/$branchName/",
      field: field,
      equalTo: equalTo,
      field2: field2,
      equalTo2: equalTo2,
      field3: field3,
      equalTo3: equalTo3,
      field4: field4,
      equalTo4: equalTo4,
    );
    clients = result.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
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
    employees = result.docs.map((doc) => Employee.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }
}
