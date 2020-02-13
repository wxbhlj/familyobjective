import 'package:flutter/material.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/states/theme_model.dart';
import 'package:provider/provider.dart';

class ThemeSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择主题颜色'),
      ),
      body: ListView( //显示主题色块
        children: Global.themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                color: e,
                height: 40,
              ),
            ),
            onTap: () {
              //主题更新后，MaterialApp会重新build
              Provider.of<ThemeModel>(context).theme = e;
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}