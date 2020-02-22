import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/cloud_api.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/routers.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/models/user.dart';
import 'package:my_family/states/user_model.dart';
import 'package:provider/provider.dart';

class FamilyPage extends StatefulWidget {
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  var _eventSubscription;
  List<Member> members;
  @override
  void initState() {
    members = Global.profile.members;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _topHeader(),
            _buildCoins(),
            _coninExchange(),
            _coninAward(),
          ],
        ),
      ),
    );
  }
Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(0),
      color: Theme.of(context).accentColor,
      child: Image.asset('images/family.jpg'),
    );
  }

Widget _buildCoins() {
  List<Widget> children = List();
  for(Member member in members) {
    children.add(
      ListTile(
          leading: Container(
            child: _getMemberHeader(member),
            height: ScreenUtil().setHeight(64),
          ),
          title: Row(children: <Widget>[
            Expanded(child: Text(member.nick),),
            Container(
            width: ScreenUtil().setWidth(200),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.end,
              children: <Widget>[
                Text((member.coinsTotal -member.coinsUsed).toString() + '  ', style: TextStyle(fontWeight: FontWeight.bold),),
                Image.asset('images/coin.png', width:ScreenUtil().setWidth(48))
              ],
            ),
          )
          ],),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            Routers.router
              .navigateTo(context, Routers.coinChangeListPage + "?memberId=" + member.userId.toString(), replace: false);
          },
        )
    );
    children.add(new Divider(height: 1,));
  }
    return Column(
      children: children,
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

Widget _coninExchange() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Image.asset("images/minus.png", width:ScreenUtil().setWidth(48), color: Colors.red),
        title: Text('金币兑换'),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          Routers.router
              .navigateTo(context, Routers.coinExchangePage, replace: false);
        },
      ),
    );
  }

Widget _coninAward() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Image.asset("images/add.png", width:ScreenUtil().setWidth(48), color: Colors.green),
        title: Text('来点奖励'),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          Routers.router
              .navigateTo(context, Routers.coinAwardPage, replace: false);
        },
      ),
    );
  }
void _getListMember() {
    getListMember(context, (){
      setState(() {
          members = Provider.of<UserModel>(context, listen: false).members;
        });
    });
  }


}