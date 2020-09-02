import 'package:gym_bar_sales/core/locator.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/services/api.dart';

class ClientModel extends BaseModel {
  Api _api = locator<Api>();

  List<Client> client;

  Future addClient({Client client, String branchName}) async {
    setState(ViewState.Busy);
    await _api.addDocument(client.toJson(), "branches/$branchName/clients");
    setState(ViewState.Idle);
  }

  Future fetchClients(branchName) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("branches/$branchName/clients");
    client =
        result.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
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
      path: "branches/$branchName/clients",
      field: field,
      equalTo: equalTo,
      field2: field2,
      equalTo2: equalTo2,
      field3: field3,
      equalTo3: equalTo3,
      field4: field4,
      equalTo4: equalTo4,
    );
    client =
        result.docs.map((doc) => Client.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }
}
