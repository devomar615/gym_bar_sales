import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/view_models/branch_model.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BranchModel>(
      onModelReady: (model) => model.fetchBranches(),
      builder: (context, model, child) => model.state == ViewState.Busy
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.business),
                  onPressed: () {
                    Navigator.pushNamed(context, "/add_branch");
                  }),
              appBar: AppBar(title: Text("الفروع")),
              body: model.branches.length > 0
                  ? ListView.builder(
                      itemCount: model.branches.length,
                      itemBuilder: (BuildContext context, int index) {
                        return model.branches == null
                            ? Navigator.pushNamed(context, "/add_branch")
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                child: item(
                                  title: (model.branches[index].name),
                                  networkImage: model.branches[index].photo,
                                  onPress: () {
                                    Navigator.pushNamed(context, '/categories',
                                        arguments: model.branches[index].name);
                                  },
                                ),
                              );
                      })
                  : Center(
                      child: Text(
                          "لم نجد اية فروع, من فضلك اضغط على الزر السفلي لاضافة اول فرع لك"),
                    ),
            ),
    );
  }
}
