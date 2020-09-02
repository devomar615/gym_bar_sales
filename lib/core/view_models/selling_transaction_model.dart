import 'package:gym_bar_sales/core/locator.dart';
import 'package:gym_bar_sales/core/models/attendance.dart';
import 'package:gym_bar_sales/core/models/selling_transaction.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import '../enums.dart';

class SellingTransactionModel extends BaseModel {
  Api _api = locator<Api>();

  List<SellingTransaction> transactions;

  Future addTransaction(Attendance data, String path) async {
    setState(ViewState.Busy);
    await _api.addDocument(data.toJson(), path);
    setState(ViewState.Idle);
  }

  Future<List<SellingTransaction>> fetchAttendance(String path) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection(path);
    transactions = result.docs
        .map((doc) => SellingTransaction.fromMap(doc.data(), doc.id))
        .toList();
    setState(ViewState.Idle);
    return transactions;
  }

  Future<SellingTransaction> getTransaactionByName(String path) async {
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////
//get
Future<SellingTransaction> getClient(String path) async {
  return null;
}

////////////////////////////////////////////////////////////////////////////////////////////
//modify
Future<SellingTransaction> updateProduct(
    String productName, productNumber) async {
  return null;
}

Future<SellingTransaction> updateEmployeeProfile(String productName) async {
  return null;
}

Future<SellingTransaction> updateClientProfile(String productName, cash) async {
  return null;
}

Future<SellingTransaction> updateCapital(String productName) async {
  return null;
}

////////////////////////////////////////////////////////////////////////////////////////////
//add
////////////////////////////////////////////////////////////////////////////////////////////
//delete
