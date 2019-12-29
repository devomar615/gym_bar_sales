import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gym_bar_sales/core/enums/viewstate.dart';
import 'package:gym_bar_sales/core/view_models/branch_model.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var floatingButtons = [
      SpeedDialChild(
          child: Icon(Icons.business),
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,
          label: 'إضافة فرع',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('FIRST CHILD')),
      SpeedDialChild(
        child: Icon(Icons.collections_bookmark),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        label: 'إضافة نوع منتج',
        labelStyle: TextStyle(fontSize: 18.0),
        onTap: () => print('SECOND CHILD'),
      ),
    ];

    return BaseView<BranchModel>(
        onModelReady: (model) => model.fetchBranches(),
        builder: (context, model, child) =>
        model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
            floatingActionButton: SpeedDial(
              overlayOpacity: 0,
              // both default to 16
              marginRight: 30,
              marginBottom: 20,
              child: Icon(Icons.add),
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              // this is ignored if animatedIcon is non null
//                  visible: true,
              // If true user is forced to close dial manually
              // by tapping main button and overlay is not rendered.
              closeManually: false,
//                  curve: Curves.bounceIn,
              onOpen: () => print('OPENING DIAL'),
              onClose: () => print('DIAL CLOSED'),
              tooltip: 'إضافة',
              backgroundColor: Colors.black,
//                  foregroundColor: Colors.black,
              elevation: 8.0,
//                  shape: CircleBorder(),
              children: floatingButtons,
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
