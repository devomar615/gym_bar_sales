import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          backgroundColor: backgroundColor != null ? backgroundColor : Colors.blueAccent,
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

  Widget formTextFieldTemplate({
    controller,
    validator,
    hint,
    ValueChanged<String> onChanged,
    secure = false,
    double height = 51,
    double left = 10,
    double right = 10,
    double bottom = 0,
    double top = 0,
    TextInputType keyboardType,
    List<TextInputFormatter> inputFormatters,
  }) {
    return Container(
      margin: EdgeInsets.only(left: left, right: right, bottom: bottom, top: top),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: height,
          child: TextFormField(
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            controller: controller,
            validator: validator,
            obscureText: secure,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              isDense: true,
//            contentPadding: EdgeInsets.only(top: height, right: 10,),
//               labelStyle: formLabelsStyle,
              labelText: hint,
//          hintStyle: TextStyle(decoration: ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            keyboardType: keyboardType,
          ),
        ),
      ),
    );
  }

  Widget formButtonTemplate({
    @required context,
    @required text,
    @required onTab,
    color = Colors.blue,
    double minWidth = 150,
    double height = 40,
  }) {
    TextStyles _textStyles = TextStyles(context: context);
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth,
      ),
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        child: Text(
          text,
          style: _textStyles.formButtonStyle(),
        ),
        onPressed: onTab,
      ),
    );
  }

  searchTextField(controller, focusNode) {
    Dimensions _dimensions = Dimensions(context);
    TextStyles _textStyles = TextStyles(context: context);
    return Padding(
        padding: EdgeInsets.symmetric(vertical: _dimensions.heightPercent(1), horizontal: _dimensions.widthPercent(1)),
        child: TextField(
          textAlign: TextAlign.right,
          controller: controller,
          focusNode: focusNode,
          style: _textStyles.searchTextFieldStyle(),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(_dimensions.heightPercent(7))),
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(_dimensions.heightPercent(7))),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor)),
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
