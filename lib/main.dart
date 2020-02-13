import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:my_family/pages/home.dart';
import 'package:my_family/pages/login.dart';
import 'package:my_family/pages/setting/init_setting.dart';
import 'package:my_family/states/theme_model.dart';
import 'package:my_family/states/user_model.dart';
import 'package:provider/provider.dart';

import 'common/global.dart';
import 'common/routers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Global.init().then((e) {

    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final router = Router();
  
  @override
  Widget build(BuildContext context) {
    Routers.configRoutes(router);
    Routers.router = router;
    
    
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
      ],
      child: Consumer2<ThemeModel, UserModel>(
        builder: (BuildContext context, themeModel,  userModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            title: '咕嘎',
            home: _firstPage(userModel), 

            onGenerateRoute: Routers.router.generator,
            debugShowMaterialGrid:false,
          );
        },
      ),
    );
  }

  Widget _firstPage(UserModel userModel) {
    if(userModel.isLogin) {
      if(userModel.user != null && userModel.user.familyRole != null && userModel.user.familyRole.length > 0) {
        return HomePage();
      } else {
        return InitSettingPage();
      }
    } else {
      return LoginPage();
    }
  }
}
