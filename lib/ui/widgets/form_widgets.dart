import 'package:flutter/material.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';

logo(imageContent) {
  return Card(
    child: Container(
      child: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          maxRadius: 100.0,
          backgroundImage: imageContent),
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
  double left = 10,
  double right = 10,
}) {
  return Container(
    margin: EdgeInsets.only(left: left, right: right),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        obscureText: secure,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelStyle: formLabelsStyle,
          labelText: hint,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
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

Widget formButtonTemplate({context, text, onTab}) {
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
