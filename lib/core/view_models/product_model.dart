import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_bar_sales/core/models/product.dart';

class ProductModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // bool loading = true;
  List<Product> _products;

  List<Product> filterProduct(String selectedCategory) {
    if (selectedCategory == "All") {
      return _products;
    } else
      return _products
          .where((product) => product.category == selectedCategory)
          .toList();
  }

  List<Product> getSelectedProducts() {
    return _products.where((product) => product.selectionNo > 0).toList();
  }

  removeProductSelectionById(productId) {
    _products.firstWhere((product) => product.id == productId).selectionNo -= 1;
    notifyListeners();
  }

  isThereSelectedProduct(){
    var selected = _products.where((product) => product.selectionNo > 0).toList();
    return selected.length == 0;
  }

  addProductSelectionById(productId) {
    _products.firstWhere((product) => product.id == productId).selectionNo += 1;
    notifyListeners();
  }

  //
  // Future addProduct({Product product, String branchName}) async {
  //   await _api.addDocument(product.toJson(), "products/branches/$branchName/");
  // }

  Future fetchProducts({branchName}) async {
    // loading = true;
    var result = await _db.collection("products/branches/$branchName/").get();
    // var result2 = await _api.getDataCollection("products/branches/$branchName/");
    _products =
        result.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    // loading = false;
    notifyListeners();
  }
}
