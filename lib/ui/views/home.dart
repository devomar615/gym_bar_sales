import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/view_models/branch_model.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import 'package:unicorndial/unicorndial.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Choo choo",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {},
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "airplane",
            backgroundColor: Colors.greenAccent,
            mini: true,
            child: Icon(Icons.airplanemode_active))));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "directions",
            backgroundColor: Colors.blueAccent,
            mini: true,
            child: Icon(Icons.directions_car))));

    return BaseView<BranchModel>(
        onModelReady: (model) => model.fetchBranches(),
        builder: (context, model, child) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
//                  Navigator.pushNamed(context, '/add');
              },
              child: Icon(Icons.add),
            ),
            appBar: AppBar(
              title: Text("Ms Amany"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () {
//            Navigator.pushNamed(context, '/download');
                    })
              ],
            ),
            body: ListView.builder(
                itemCount: model.branches.length,
                itemBuilder: (BuildContext context, int index) {
                  return model.branches == null
                      ? Navigator.pushNamed(context, "/add_branch")
                      : item(
                          image: model.branches[index].photo,
                          onPress: () {},
                          title: (model.branches[index].name));
                })));
  }
}
