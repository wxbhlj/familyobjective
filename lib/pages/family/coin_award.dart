import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/models/member.dart';


import 'package:shared_preferences/shared_preferences.dart';

class CoinAwardPage extends StatefulWidget {
  @override
  _CoinAwardPageState createState() => _CoinAwardPageState();
}

class _CoinAwardPageState extends State<CoinAwardPage> {
  final TextEditingController _titleController =
      TextEditingController.fromValue(TextEditingValue(text: ''));

  final TextEditingController _coinsController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  var ownerId;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('奖励金币'),
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
              Icon(Icons.people, color: Theme.of(context).accentColor),
              Text(
                ' 奖励给谁',
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
              Icon(Icons.insert_comment, color: Theme.of(context).accentColor),
              Text(
                ' 奖励原因',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _titleController,
            decoration: InputDecoration(hintText: '例如：小朋友帮忙做家务'),
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
              Icon(Icons.monetization_on, color: Theme.of(context).accentColor),
              Text(
                ' 金币数量',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _coinsController,
            decoration: InputDecoration(hintText: '奖励的金币数量'),
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
          '给予奖励',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {

          if(ownerId == null || ownerId < 1) {
            Fluttertoast.showToast(
                  msg:'请选择被奖励人', gravity: ToastGravity.CENTER);
            return ;
          }
          String title = _titleController.text;
          if(title.length < 2) {
            Fluttertoast.showToast(
                  msg:'请输入奖励原因', gravity: ToastGravity.CENTER);
            return ;
          }

          String coins = _coinsController.text;
          if(coins.length < 1 || int.parse(coins) < 1) {
            Fluttertoast.showToast(
                  msg:'请输入奖励的金币个数', gravity: ToastGravity.CENTER);
            return ;
          }

          var formData = {
            "changeType": 1,
            "coins": coins,

            "familyId": Global.profile.user.familyId,
            "reason": title,
            "userId": ownerId
          };
          HttpUtil.getInstance()
              .post("api/v1/ums/coinsChange/award", formData: formData)
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
