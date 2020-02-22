import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/models/member.dart';

class NewObjectivePage extends StatefulWidget {
  @override
  _NewObjectivePageState createState() => _NewObjectivePageState();
}

class _NewObjectivePageState extends State<NewObjectivePage> {
  final TextEditingController _titleController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController _weeksController =
      TextEditingController.fromValue(TextEditingValue(text: '4'));

  final TextEditingController _coinsController =
      TextEditingController.fromValue(TextEditingValue(text: '1'));
  var daysInWeek = 5;
  var ownerId;

  List<String> _chips = <String>['今天', '明天'];
  String startDay = '明天';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新建目标'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildOwners(),
            _buildInputTitle(),
            _buildInputDays(),
            _buildStartDay(),
            _buildReward(),
            Container(
              height: ScreenUtil().setHeight(100),
              child: Text(''),
            )
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButtion(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildOwners() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.timer, color: Theme.of(context).accentColor),
              Text(
                ' 目标执行人',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            width: ScreenUtil().setWidth(750),
            child: DropdownButton(
              items: _buildOwnerItems(),
              hint: new Text('选择目标执行人'), //当没有默认值的时候可以设置的提示
              isExpanded: true,
              value: ownerId, //下拉菜单选择完之后显示给用户的值
              onChanged: (val) {
                //下拉菜单item点击之后的回调
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
                ' 目标内容',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _titleController,
            decoration: InputDecoration(hintText: '例如：每天做100个俯卧撑'),
            maxLines: 1,
          )
        ],
      ),
    );
  }

  Widget _buildInputDays() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.cached, color: Theme.of(context).accentColor),
              Text(
                ' 持续时间',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Text(
                  '每周打卡  ',
                  style: TextStyle(),
                ),
                _buildDaysInWeek(),
                Text(
                  '，坚持 ',
                  style: TextStyle(),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _weeksController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(hintText: ''),
                    maxLines: 1,
                  ),
                ),
                Text(
                  '周',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysInWeek() {
    return DropdownButton(
      value: daysInWeek,
      items: <DropdownMenuItem>[
        DropdownMenuItem(
          value: 1,
          child: Text('1次'),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('2次'),
        ),
        DropdownMenuItem(
          value: 3,
          child: Text('3次'),
        ),
        DropdownMenuItem(
          value: 4,
          child: Text('4次'),
        ),
        DropdownMenuItem(
          value: 5,
          child: Text('5次'),
        ),
        DropdownMenuItem(
          value: 6,
          child: Text('6次'),
        ),
        DropdownMenuItem(
          value: 7,
          child: Text('7次'),
        ),
      ],
      onChanged: (val) {
        setState(() {
          daysInWeek = val;
        });
      },
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 16),
      underline: Text(''),
    );
  }

  Iterable<Widget> get chipWidgets sync* {
    for (String chip in _chips) {
      yield Padding(
        padding: EdgeInsets.all(10),
        child: ChoiceChip(
          backgroundColor: Colors.black12,
          label: Text(chip),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelPadding: EdgeInsets.only(left: 10, right: 10),
          onSelected: (val) {
            setState(() {
              startDay = val ? chip : startDay;
            });
          },
          selectedColor: Theme.of(context).accentColor,
          selected: startDay == chip,
        ),
      );
    }
  }

  Widget _buildStartDay() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.timer, color: Theme.of(context).accentColor),
              Text(
                ' 开始时间',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              children: chipWidgets.toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReward() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.attach_money, color: Theme.of(context).accentColor),
              Text(
                ' 打卡奖励',
                style: TextStyle(fontWeight: FontWeight.w800),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Text(' 每完成一次打卡，奖励金币'),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _coinsController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(hintText: ''),
                    maxLines: 1,
                  ),
                ),
                Text(
                  '个',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
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
          '立即开始',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          if(ownerId == null || ownerId < 1) {
            Fluttertoast.showToast(
                  msg:'请选择目标执行人', gravity: ToastGravity.CENTER);
            return ;
          }
          String title = _titleController.text;
          if(title.length < 5) {
            Fluttertoast.showToast(
                  msg:'请输入目标内容', gravity: ToastGravity.CENTER);
            return ;
          }
       
          int now = DateTime.now().millisecondsSinceEpoch;
          int totalDays = 7 * int.parse(_weeksController.text);
          int msInDay = 1000 * 60 * 60 * 24;

          var formData = {
            "coins": _coinsController.text,
            "endDate": startDay == '明天'
                ? now + (totalDays + 1) * msInDay
                : now + (totalDays) * msInDay,
            "familyId": Global.profile.user.familyId,
            "planTimes": daysInWeek * int.parse(_weeksController.text),
            "signTimes": 0,
            "startDate": startDay == '明天' ? now + msInDay : now,
            "times": daysInWeek,
            "title": title,
            "userId": ownerId,
            "weeks": _weeksController.text
          };
          HttpUtil.getInstance()
              .post("api/v1/obj/objective", formData: formData)
              .then((val) {
            print(val);
            if (val['code'] == '10000') {
              Fluttertoast.showToast(
                  msg: '新建成功', gravity: ToastGravity.CENTER);
              GlobalEventBus.fireRefreshObjectiveList(ownerId);
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
