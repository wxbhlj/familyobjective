import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_family/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.pink,
  Colors.orange
];

class Global {
  static SharedPreferences _prefs;

  static Profile profile = Profile();
  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {

    _prefs = await SharedPreferences.getInstance();

    var _profile = _prefs.getString("_profile");
    if (_profile != null) {
 
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {

        print(e);
      }
    } 
  }

  static saveProfile() =>
      _prefs.setString("_profile", jsonEncode(profile.toJson()));
}