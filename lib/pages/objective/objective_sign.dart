import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/models/objective.dart';
import 'package:my_family/states/user_model.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ObjectiveSignPage extends StatelessWidget {

  final TextEditingController _titleController =
      TextEditingController.fromValue(TextEditingValue(text: ''));

  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs = Global.prefs;
    String title = prefs.getString("sign_title");
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          _buildComments(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtion(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildComments() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _titleController,
        decoration: InputDecoration(hintText: '写下您的心得感受 [可以不填]'),
        maxLines: 4,
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
          '完成打卡',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
      
          var formData = {
            "comments": _titleController.text,
            "creator": Global.profile.user.userId,
            "creatorNick": Global.profile.user.nick,
            "objectiveId": Global.prefs.getInt("sign_objectiveId")
          };
          HttpUtil.getInstance()
              .post("api/v1/obj/objectiveSign", formData: formData)
              .then((val) {
            print(val);
            if (val['code'] == '10000') {
              Objective obj = Global.profile.getObjective(Global.prefs.getInt("sign_objectiveId"));
              obj.lastSignTime = DateTime.now().millisecondsSinceEpoch;
              obj.signTimes++;
              Provider.of<UserModel>(context, listen: true).objective = obj;
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
