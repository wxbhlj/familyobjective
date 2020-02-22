import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/models/member.dart';


import 'package:shared_preferences/shared_preferences.dart';

class CoinExchangePage extends StatefulWidget {
  @override
  _CoinExchangePageState createState() => _CoinExchangePageState();
}

class _CoinExchangePageState extends State<CoinExchangePage> {
  final TextEditingController _titleController =
      TextEditingController.fromValue(TextEditingValue(text: ''));

  final TextEditingController _coinsController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  var ownerId;

  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs = Global.prefs;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('金币兑换'),
      ),
      body: Column(
        children: <Widget>[
          _buildOwners(context),
          _buildInputTitle(),
          _buildInputCoins(context),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtion(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildOwners(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.timer, color: Theme.of(context).accentColor),
              Text(
                ' 谁要兑换',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            width: ScreenUtil().setWidth(750),
            child: DropdownButton(
              items: _buildOwnerItems(),
              hint: new Text('选择家庭成员'), //当没有默认值的时候可以设置的提示
              isExpanded: true,
              value: ownerId, //下拉菜单选择完之后显示给用户的值
              onChanged: (val) {
                setState(() {
                  ownerId = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem> _buildOwnerItems() {
    List<Member> members = Global.profile.members;
    List<DropdownMenuItem> list = new List();
    for (Member m in members) {
      list.add(DropdownMenuItem(
        value: m.userId,
        child: Text(m.nick),
      ));
    }
    return list;
  }

  Widget _buildInputTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.my_location, color: Theme.of(context).accentColor),
              Text(
                ' 兑换内容',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _titleController,
            decoration: InputDecoration(hintText: '例如：兑换的物品名称'),
            maxLines: 1,
          )
        ],
      ),
    );
  }

  Widget _buildInputCoins(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.my_location, color: Theme.of(context).accentColor),
              Text(
                ' 金币数量',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _coinsController,
            decoration: InputDecoration(hintText: '所需要花费的金币个数'),
            maxLines: 1,
          )
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtion(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(80),
      child: RaisedButton(
        child: Text(
          '完成兑换',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {

          if(ownerId == null || ownerId < 1) {
            Fluttertoast.showToast(
                  msg:'请选择兑换人', gravity: ToastGravity.CENTER);
            return ;
          }
          String title = _titleController.text;
          if(title.length < 2) {
            Fluttertoast.showToast(
                  msg:'请输入兑换内容', gravity: ToastGravity.CENTER);
            return ;
          }

          String coins = _coinsController.text;
          if(coins.length < 1 || int.parse(coins) < 1) {
            Fluttertoast.showToast(
                  msg:'请输入需要花费的金币', gravity: ToastGravity.CENTER);
            return ;
          }

          var formData = {
            "changeType": 0,
            "coins": "-" + coins,

            "familyId": Global.profile.user.familyId,
            "reason": title,
            "userId": ownerId
          };
          HttpUtil.getInstance()
              .post("api/v1/ums/coinsChange/exchange", formData: formData)
              .then((val) {
            print(val);
            if (val['code'] == '10000') {
              GlobalEventBus.fireMemberChanged();
              Navigator.of(context).pop();
            } else {
              Fluttertoast.showToast(
                  msg: val['message'], gravity: ToastGravity.CENTER);
            }
          });
        },
      ),
    );
  }
}
