import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:my_family/pages/family/coin_award.dart';
import 'package:my_family/pages/family/coin_change_list.dart';
import 'package:my_family/pages/family/coin_exchange.dart';
import 'package:my_family/pages/home.dart';
import 'package:my_family/pages/login.dart';
import 'package:my_family/pages/objective/objective_new.dart';
import 'package:my_family/pages/objective/objective_sign.dart';
import 'package:my_family/pages/setting/add_member.dart';
import 'package:my_family/pages/setting/init_setting.dart';
import 'package:my_family/pages/setting/theme_setting.dart';



class Routers {
  static Router router;

  static String root = '/';
  static String loginPage = '/login';
  static String homePage = '/homePage';
  static String initSettingPage = '/initSettingPage';
  static String themeSettingPage = '/themeSettingPage';
  static String addMemeberPage = '/addMemeberPage';
  static String newObjectivePage = '/newObjectivePage';
  static String objectiveSignPage = '/objectiveSignPage';
  static String coinExchangePage = '/coinExchangePage';
  static String coinChangeListPage = '/coinChangeListPage';
  static String coinAwardPage = '/coinAwardPage';

 
  static void configRoutes(Router router) {
    Routers.router = router;
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return Text('not found');
    });
    router.define(loginPage, handler: _buildHandler(LoginPage()));
    router.define(homePage, handler: _buildHandler(HomePage()));
    router.define(initSettingPage, handler:_buildHandler(InitSettingPage()));
    router.define(themeSettingPage, handler:_buildHandler(ThemeSettingPage()));
    router.define(newObjectivePage, handler:_buildHandler(NewObjectivePage()));
    router.define(objectiveSignPage, handler:_buildHandler(ObjectiveSignPage()));
    router.define(coinExchangePage, handler:_buildHandler(CoinExchangePage()));
    router.define(coinAwardPage, handler:_buildHandler(CoinAwardPage()));

    
    router.define(coinChangeListPage, handler:Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CoinChangeListPage(params['memberId'].first);
    }));
    

    router.define(addMemeberPage, handler:Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String memberId = '0';
      if (params['memberId'] != null) {
        memberId = params['memberId'].first;
      } 
      print("memberId = " + memberId);
      return AddMemeberPage(memberId);
    }));
  }

  static Handler _buildHandler(Widget widget) {
    return Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return widget;
    });
  }

}
