import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/dimensions.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

class FormWidget {
  final context;

  FormWidget({@required this.context});

  Widget logo({imageContent, backgroundColor}) {
    Dimensions _dimensions = Dimensions(context);
    return Card(
      child: Container(
        child: CircleAvatar(
          child: ClipOval(child: imageContent),
          backgroundColor:
              backgroundColor != null ? backgroundColor : Colors.blueAccent,
          maxRadius: _dimensions.heightPercent(30),
//          backgroundImage: imageContent,
        ),
      ),
      elevation: _dimensions.heightPercent(1),
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.blueAccent,
    );
  }

  searchTextField(controller, focusNode) {
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: _dimensions.heightPercent(1),
            horizontal: _dimensions.widthPercent(1)),
        child: TextField(
          textAlign: TextAlign.right,
          controller: controller,
          focusNode: focusNode,
          style: _textStyles.searchTextFieldStyle(),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(_dimensions.heightPercent(7))),
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(_dimensions.heightPercent(7))),
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              suffixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: "... ابحث هنا",
              hintStyle: _textStyles.searchTextFieldHintStyle(),
              contentPadding: EdgeInsets.only(
                  left: _dimensions.heightPercent(1),
                  right: _dimensions.heightPercent(1),
                  top: _dimensions.heightPercent(1.5),
                  bottom: _dimensions.heightPercent(1.5))),
        ));
  }
}
