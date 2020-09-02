import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/attendance.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';

import '../locator.dart';

class AttendanceModel extends BaseModel {
  Api _api = locator<Api>();

  List<Attendance> attendance;

  Future addProduct(Attendance data, String path) async {
    setState(ViewState.Busy);
    await _api.addDocument(data.toJson(), path);
    setState(ViewState.Idle);
  }

  Future<List<Attendance>> fetchAttendance(String path) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection(path);
    attendance = result.docs
        .map((doc) => Attendance.fromMap(doc.data(), doc.id))
        .toList();
    setState(ViewState.Idle);
    return attendance;
  }
}
