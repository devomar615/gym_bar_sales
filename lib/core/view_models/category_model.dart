import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/services/api.dart';

class CategoryModel extends ChangeNotifier {
  Api _api;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Category> _categories;
  String _selectedCategory = "All";

  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();

  }

  List<Category> get categories => _categories;

  String get selectedCategory => _selectedCategory;

  // set selectedCategory(String value) {
  //   _selectedCategory = value;
  // }


  Future addCategory(Category category) async {
    await _api.addDocument(category.toJson(), "categories");
  }

  Future fetchCategories() async {
    var result = await _db.collection("categories").get();

    // var result = await _api.getDataCollection("categories");
    _categories =
        result.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList();
  }
}
