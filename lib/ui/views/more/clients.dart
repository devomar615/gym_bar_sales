import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/ui/widgets/clients/clients_list.dart';
import 'package:gym_bar_sales/ui/widgets/clients/one_client_info.dart';

SortSelection selectedSort;
File file;
class Clients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("العملاء"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Row(
          children: [
            ClientsList(),
            OneClientInfo(),
            SizedBox(
              width: 20
            ),
          ],
        ),
      ),
    );
  }
}
