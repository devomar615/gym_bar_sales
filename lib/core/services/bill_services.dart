import 'package:flutter/material.dart';

class BillServices extends ChangeNotifier {
  String _selectedBuyerType = "Client";

  String get selectedBuyerType => _selectedBuyerType;

  set selectedBuyerType(String selectedBuyerType) {
    _selectedBuyerType = selectedBuyerType;
    notifyListeners();
  }
}
