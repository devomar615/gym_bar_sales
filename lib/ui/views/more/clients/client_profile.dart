// import 'package:flutter/material.dart';
// import 'package:gym_bar_sales/core/models/client.dart';
// import 'package:gym_bar_sales/ui/shared/text_styles.dart';
// import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
//
// class ClientProfile extends StatelessWidget {
//   final Client client;
//
//   ClientProfile({this.client});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: GestureDetector(
//       onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//       child: Center(
//         child: ListView(
//           children: <Widget>[
// SizedBox(height: 15,)          ,  logo(imageContent:
//               Image.asset(
//                 "assets/images/banana.jpg",
//                 width: double.infinity,
//                 height: double.infinity,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             SizedBox(height: 15,)          ,             Center(
//                 child: Text(
//               client.name,
//               style: headerStyle,
//             )),
//             SizedBox(height: 15,)          , //                header("الوصف"),
//             RaisedButton(
//               onPressed: () {
//                 // dialogue(context, "سحب", () {
//                 //   print("سحب");
//                 // });
//               },
//               child: Text("سحب"),
//             ),
//             RaisedButton(
//               onPressed: () {
//                 // dialogue(context, "ايداع", () {
//                 //   print("ايداع");
//                 // });
//               },
//               child: Text("ايداع"),
//             ),
//           ],
//         ),
//       ),
//     ));
// //      SafeArea(
// //      child: Scaffold(
// //        appBar: AppBar(
// //          title: Text(employee.name),
// //        ),
// //        body: Center(
// //          child: Column(
// //            children: <Widget>[
//
// //            ],
// //          ),
// //        ),
// //      ),
// //    );
//   }
// }
