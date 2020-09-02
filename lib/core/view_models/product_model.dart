import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/services/api.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import '../locator.dart';

class ProductModel extends BaseModel {
  Api _api = locator<Api>();

  List<Product> products;

  Future<List<Product>> fetchProducts({categoryName, branchName}) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection(
        "products/branches/$branchName/categories/$categoryName");
    products =
        result.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
    return products;
  }

  // Stream<QuerySnapshot> fetchProductsAsStream(String path) {
  //   setState(ViewState.Busy);
  //   var api = _api.streamDataCollection(path);
  //   setState(ViewState.Idle);

  //   return api;
  // }

  Future addProduct(
      {Product product, String branchName, String categoryName}) async {
    setState(ViewState.Busy);
    await _api.addDocument(product.toJson(),
        "products/branches/$branchName/categories/$categoryName");
    setState(ViewState.Idle);
  }

  Future<Product> getProductById(String id, String path) async {
    setState(ViewState.Busy);
    var doc = await _api.getDocumentById(id, path);
    Product product = Product.fromMap(doc.data(), doc.id);
    setState(ViewState.Idle);
    return product;
  }

  Future<Product> getProductByBranch(String path) async {
    return null;
  }

  Future removeProduct(String id, String path) async {
    setState(ViewState.Busy);

    await _api.removeDocument(id, path);
    setState(ViewState.Idle);

    return;
  }
}
