import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/models/branch.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/services/api.dart';

class BranchModel extends ChangeNotifier {
  Api _api;

  List<Branch> branches;

  Future addBranch(Branch branch) async {
    // setBusy(true);
    await _api.addDocument(branch.toJson(), "branches");
    // setBusy(false);
  }

  Future fetchBranches() async {
    // setBusy(true);
    var result = await _api.getDataCollection("branches");
    branches = result.docs
        .map((doc) => Branch.fromMap(doc.data(), doc.id))
        .toList();
    // setBusy(false);
  }
}
