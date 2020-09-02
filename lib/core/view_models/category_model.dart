import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/base_model.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/services/api.dart';

import '../locator.dart';

class CategoryModel extends BaseModel {
  Api _api = locator<Api>();
  List<Product> products;
  List<Category> categories;

  Future addCategory(Category category) async {
    setState(ViewState.Busy);
    await _api.addDocument(category.toJson(), "categories");
    setState(ViewState.Idle);
  }

  Future<List<Category>> fetchAttendance(String path) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection(path);
    categories =
        result.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
    return categories;
  }

  Future fetchCategories() async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("categories");
    categories =
        result.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }

  Future fetchCategoriesAndProducts({branchName}) async {
    setState(ViewState.Busy);
    var result = await _api.getDataCollection("categories");
    categories =
        result.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList();

    var result2 =
        await _api.getDataCollection("products/branches/$branchName/");
    products =
        result2.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    setState(ViewState.Idle);
  }
}
