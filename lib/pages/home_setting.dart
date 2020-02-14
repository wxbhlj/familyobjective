import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/routers.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/models/user.dart';
import 'package:my_family/states/user_model.dart';
import 'package:my_family/widgets/dialog.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _eventSubscription;
  List<Member> members = List();

  @override
  void initState() {
    _getListMember();
    _eventSubscription =
        GlobalEventBus().event.on<CommonEventWithType>().listen((event) {
      print("C onEvent:" + event.eventType);
      if (event.eventType == EVENT_MEMBER_CHANGED) {
        _getListMember();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _eventSubscription.cancel();
  }

  void _getListMember() {
    HttpUtil.getInstance()
        .get("api/v1/ums/family/members/" +
            Global.profile.user.familyId.toString())
        .then((val) {
      if (val['code'] == '10000') {
        members.clear();
        List<Member> list = new List<Member>();
        val['data'].forEach((v) {
          Member member = Member.fromJson(v);
          list.add(member);
          if(member.userId == Global.profile.user.userId) {
            User user = Global.profile.user;
            user.nick = member.nick;
            user.familyRole = member.familyRole;
            Provider.of<UserModel>(context, listen: false).user = user;
          }
        });
        Provider.of<UserModel>(context, listen: false).members = list;

        setState(() {
          members = list;
        });
      } else {
        Fluttertoast.showToast(
            msg: val['message'], gravity: ToastGravity.CENTER);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              showConfirmDialog(context, '确定要退出吗', () {
                Provider.of<UserModel>(context, listen: false).user = null;
                exit(0);
              });
            },
            //backgroundColor: Colors.green,
            label: Text(''),
            icon: Icon(
              Icons.exit_to_app,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _topHeader(),
          _themeColor(),
          _homeMember(),
          Divider(),
          Expanded(
            child: Container(
              width: ScreenUtil().setWidth(750),
              child: _homeMemberList(),
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _topHeader() {
    String nick = Global.profile.user != null ? Global.profile.user.nick : "";

    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(0),
      color: Theme.of(context).accentColor,
      child: Image.asset('images/family.jpg'),
    );
  }

  Widget _themeColor() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Icon(
          Icons.colorize,
          color: Theme.of(context).accentColor,
        ),
        title: Text('主题颜色'),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          Routers.router
              .navigateTo(context, Routers.themeSettingPage, replace: false);
        },
      ),
    );
  }

  Widget _homeMember() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, bottom: 0, right: 20),
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(
            '家庭成员:',
            style: TextStyle(fontSize: 16),
          ),),
          FlatButton.icon(
            onPressed: () async {
              Routers.router
              .navigateTo(context, Routers.addMemeberPage, replace: false);
            },
            //backgroundColor: Colors.green,
            label: Text('添加'),
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _homeMemberList() {
    return ListView.separated(
      itemCount: members.length,
      itemBuilder: (BuildContext context, int pos) {
        return ListTile(
          leading: _getMemberHeader(members[pos]),
          title: Text(members[pos].nick),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Routers.router.navigateTo(
                context,
                Routers.addMemeberPage +
                    "?memberId=" +
                    members[pos].userId.toString(),
                replace: false);
          },
        );
      },
      separatorBuilder: (BuildContext context, int pos) {
        return Divider();
      },
    );
  }

  Widget _getMemberHeader(Member member) {
    if (member.familyRole == 'HUSBAND') {
      return Image.asset('images/dad.png');
    } else if (member.familyRole == 'WIFE') {
      return Image.asset('images/mum.png');
    } else if (member.familyRole == 'SON') {
      return Image.asset('images/boy.png');
    } else {
      return Image.asset('images/girl.png');
    }
  }


}
