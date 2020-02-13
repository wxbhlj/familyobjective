import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildClearButton(TextEditingController c) {
  return IconButton(
    icon: Icon(
      Icons.clear,
      color: Colors.black26,
    ),
    onPressed: () {
      c.clear();
    },
  );
}


Widget buildInputWithTitle(
    TextEditingController controller, title, String text, Function fun) {
  return Row(
    children: <Widget>[
      Container(
        width: ScreenUtil().setWidth(160),
        child: Text(title + ':', style: TextStyle(fontSize: 16, color: Colors.black45),),
      ),
      Expanded(
        child: TextField(
            keyboardType: TextInputType.text,
            controller: controller,
            decoration: InputDecoration(hintText: text),
            onTap: fun,),
      ),
    ],
  );
}

Widget buildInput(
    TextEditingController controller, IconData icon, String text, bool isPwd) {
  return Row(
    children: <Widget>[
      buildIcon(icon),
      Expanded(
        child: TextField(
            keyboardType: TextInputType.text,
            controller: controller,
            decoration: InputDecoration(hintText: text),
            obscureText: isPwd),
      ),
    ],
  );
}

Widget buildInput2(
    TextEditingController controller, IconData icon, String text, bool isPwd, Function fun) {
  return Row(
    children: <Widget>[
      buildIcon(icon),
      Expanded(
        child: TextField(
            keyboardType: TextInputType.text,
            controller: controller,
            decoration: InputDecoration(hintText: text),
            obscureText: isPwd,
            onTap: fun,),
      ),
    ],
  );
}

Widget buildIcon(IconData icon) {
  if (icon != null) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
      child: Icon(
        icon,
        color: Colors.black26,
        size: 32,
      ),
    );
  } else {
    return Text('');
  }
}