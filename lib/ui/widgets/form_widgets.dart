import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

Widget logo({imageContent, backgroundColor}) {
  return Card(
    child: Container(
      child: CircleAvatar(
        child: ClipOval(child: imageContent),
        backgroundColor: backgroundColor != null ? backgroundColor : Colors.blueAccent,
        maxRadius: 80.0,
//          backgroundImage: imageContent,
      ),
    ),
    elevation: 18.0,
    shape: CircleBorder(),
    clipBehavior: Clip.antiAlias,
    color: Colors.blueAccent,
  );
}

formTextFieldTemplate({
  controller,
  validator,
  hint,
  ValueChanged<String> onChanged,
  secure = false,
  double height = 51,
  double width,
  double left = 10,
  double right = 10,
  double bottom = 0,
  double top = 0,
}) {
  return Container(
    margin: EdgeInsets.only(left: left, right: right, bottom: bottom, top: top),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: height,
        width: width,
        child: TextFormField(
          onChanged: onChanged,
          controller: controller,
          validator: validator,
          obscureText: secure,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            isDense: true,
//            contentPadding: EdgeInsets.only(top: height, right: 10,),
            labelStyle: formLabelsStyle,
            labelText: hint,
//          hintStyle: TextStyle(decoration: ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

formTitle(title) {
  return Text(title, style: formTitleStyle);
}

Widget formButtonTemplate({
  context,
  text,
  onTab,
  color = Colors.blueAccent,
}) {
  return ButtonTheme(
    minWidth: 300.0,
    height: 40,
    child: RaisedButton(
      color: Colors.blueAccent,
      child: Text(
        text,
        style: formButtonStyle,
      ),
      onPressed: onTab,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

searchTextField(controller, focusNode, context) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              borderSide: BorderSide(color: Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            suffixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: "Search here...",
            hintStyle: TextStyle(color: Colors.black54),
            contentPadding: const EdgeInsets.only(left: 16, right: 20, top: 14, bottom: 14)),
      ));
}
