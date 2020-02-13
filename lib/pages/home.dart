import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/pages/home_function.dart';
import 'package:my_family/pages/home_index.dart';
import 'package:my_family/pages/home_setting.dart';
import 'package:my_family/pages/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> list = List();
  var _eventSubscription;

  @override
  void initState() {
    list..add(IndexPage())..add(SettingPage());
    _eventSubscription =
        GlobalEventBus().event.on<CommonEventWithType>().listen((event) {
      print("C onEvent:" + event.eventType);
      if (event.eventType == EVENT_TOKEN_ERROR) {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new LoginPage()),
            (route) => route == null);
      }
    });
    super.initState(); //无名无参需要调用
  }

  @override
  void dispose() {
    super.dispose();
    _eventSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.my_location,
            ),
            title: Text('目标'),
          ),
          /*BottomNavigationBarItem(
              icon: Icon(
                Icons.functions,
              ),
              title: Text('功能'),
              ),*/
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            title: Text('设置'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _buildFloatingActionButtion(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButtion(context) {
    return FloatingActionButton(
      onPressed: () async {
        //Routers.router.navigateTo(context, Routers.customerTopicNew);
      },
      //backgroundColor: Colors.green,
      tooltip: '新建目标',
      child: Icon(Icons.add),
    );
  }
}
