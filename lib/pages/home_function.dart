import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FunctionPage extends StatefulWidget {
  @override
  _FunctionPageState createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildPersonCard(),
            _buildPersonCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonCard() {
    return Card(
      // color: Colors.blue[50],
      margin: EdgeInsets.all(10),
      elevation: 2,
      child: Container(
        width: ScreenUtil().setWidth(710),
        height: 140,
        child: Row(
          children: <Widget>[_buildAvatar(), _buildPersonInfo()],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: ScreenUtil().setWidth(120),
      height: 120,
      child: Image.asset('images/dad.png'),
    );
  }

  Widget _buildPersonInfo() {
    return Container(
      //color: Colors.green,
      margin: EdgeInsets.only(top: 20, right: 0),
      width: ScreenUtil().setWidth(512),
      height: 120,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            //width: ScreenUtil().setWidth(512),
            //color: Colors.red,
            margin: EdgeInsets.only(bottom: 40),
            child: Text(
              '小布丁她爸',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text('达成率 56%'), Text('金币 25')],
          )
        ],
      ),
    );
  }
}