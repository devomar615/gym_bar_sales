import 'package:gym_bar_sales/core/models/branch.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/services/api.dart';

import '../locator.dart';

class BranchModel extends BaseModel {
  Api _api = locator<Api>();

  List<Branch> branches;

  Future addBranch(Branch branch) async {
    setState(ViewState.Busy);
    await _api.addDocument(branch.toJson(), "branches");
    setState(ViewState.Idle);
  }

  Future fetchBranches() async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("branches");
    branches = result.docs
        .map((doc) => Branch.fromMap(doc.data(), doc.id))
        .toList();
    setState(ViewState.Idle);
  }
}
