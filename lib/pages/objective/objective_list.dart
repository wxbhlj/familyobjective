import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/routers.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/models/objective.dart';
import 'package:my_family/states/user_model.dart';
import 'package:my_family/widgets/progress.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObjectiveListPage extends StatefulWidget {
  int userId;
  ObjectiveListPage(this.userId);

  @override
  _ObjectiveListPageState createState() => _ObjectiveListPageState(userId);
}

class _ObjectiveListPageState extends State<ObjectiveListPage> {
  int userId;
  _ObjectiveListPageState(this.userId);

  List<Objective> objectives;
  var _eventSubscription;

  @override
  void initState() {
    super.initState();
    _getObjectiveList();
    _eventSubscription =
        GlobalEventBus().event.on<CommonEventWithType>().listen((event) {
      //print("C onEvent:" + event.eventType);
      print(event.userId.toString() + ' == ' + userId.toString());
      if (event.eventType == EVENT_REFRESH_OBJECTIVELIST) {
        if (event.userId == userId) {
          _refreshObjectiveList();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10,bottom: 0),
      child: RefreshIndicator(
        onRefresh: () => _refreshObjectiveList(),
        child: _buildObjectiveList(),
      ),
    );
  }

  

  Widget _buildObjectiveList() {
    return ListView.separated(
      itemCount: objectives == null ? 0 : objectives.length,
      itemBuilder: (BuildContext context, int pos) {
        return _buildObjective(objectives[pos]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black38,
          height: 10,
        );
      },
    );
  }

  Widget _buildObjective(Objective o) {
    return Container(
      //elevation: 1,
      child: Container(
        width: ScreenUtil().setWidth(710),
        height: 80,
        child: Column(
          children: <Widget>[
            _buildObjectiveTitle(o.title, o.id),
            _buildObjectiveProgress(o)
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveTitle(title, oid) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          /*
          Container(
            height: ScreenUtil().setHeight(48),
            child: PopupMenuButton(
                padding: EdgeInsets.all(0),
                onSelected: (String value) {
                  setState(() {});
                },
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                      new PopupMenuItem(
                          value: "选项一的内容", child: new Text("选项一")),
                      new PopupMenuItem(value: "选项二的内容", child: new Text("选项二"))
                    ]),
          )*/
        ],
      ),
    );
  }

  Widget _buildObjectiveProgress(Objective o) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(o.startDate);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(o.endDate);
    DateTime now = DateTime.now();
    int actProgress = (o.signTimes * 100 / o.planTimes).toInt();
    int shouldProgress =
        (now.difference(start).inDays * 100 / end.difference(start).inDays)
            .toInt();

    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  //width: ScreenUtil().setWidth(500),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '进度 ' +
                            o.signTimes.toString() +
                            '/' +
                            o.planTimes.toString(),
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(
                        actProgress < shouldProgress ? '    [加油呀]' : '',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                MyProgressWidget(actProgress, ScreenUtil().setWidth(480)),
              ],
            ),
          ),
          _buildSignButton(o)
        ],
      ),
    );
  }

  Widget _buildSignButton(Objective o) {
    DateTime now = DateTime.now();

    if (o.lastSignTime != null) {
      DateTime sign = DateTime.fromMillisecondsSinceEpoch(o.lastSignTime);
      if (now.day == sign.day &&
          now.year == sign.year &&
          sign.month == now.month) {
        return Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            '今日已打卡',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
        );
      }
    }

    return FlatButton.icon(
      icon: Icon(
        Icons.done,
        color: Colors.white,
      ),
      color: Colors.green,
      label: Text(
        '打卡',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        SharedPreferences prefs = Global.prefs;
        prefs.setInt("sign_objectiveId", o.id);
        prefs.setString("sign_title", o.title);
        Routers.router.navigateTo(
          context,
          Routers.objectiveSignPage,
        );
      },
      padding: EdgeInsets.all(0),
    );
  }

  _getObjectiveList() async {
   
    List<Objective> familyObjectives =
        Provider.of<UserModel>(context, listen: false).objectives;
    if (familyObjectives != null && familyObjectives.length > 0) {
      setState(() {
        objectives = _getUserObjecttiveList(familyObjectives);
      });
      return;
    } else {
      _refreshObjectiveList();
    }
  }

  List<Objective> _getUserObjecttiveList(List<Objective> all) {
    List<Objective> list = List();
    for (Objective o in all) {
      if (o.userId == userId) {
        list.add(o);
      }
    }
    return list;
  }

  Future<Null> _refreshObjectiveList() async {
    await HttpUtil.getInstance()
        .get(
      "api/v1/obj/objective/unfinished/" +
          Global.profile.user.familyId.toString(),
    )
        .then((val) {
      if (val['code'] == '10000') {
        if (objectives != null) {
          objectives.clear();
        } else {
          objectives = List();
        }
        List<Objective> list = new List<Objective>();
        val['data'].forEach((v) {
          Objective member = Objective.fromJson(v);
          list.add(member);
        });
        Provider.of<UserModel>(context, listen: false).objectives = list;
        setState(() {
          objectives = _getUserObjecttiveList(list);
        });
      } else {
        Fluttertoast.showToast(
            msg: val['message'], gravity: ToastGravity.CENTER);
      }
    });
  }
}
