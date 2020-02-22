import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_family/common/cloud_api.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/routers.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/pages/objective/objective_list.dart';
import 'package:my_family/states/user_model.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  List<ObjectiveListPage> listViews;

  @override
  void initState() {
    List<Member> members = Global.profile.members;
  
      _tabController = new TabController(vsync: this, length: members.length == 0?1:members.length);
      listViews = _tabViews(Global.profile.members);
   
    
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _tabs(List<Member> members) {
    List<Widget> tabs = List();
    tabs.add(Tab(
              text: Global.profile.user.nick,
            ));
    for(Member m in members) {
      if(m.userId != Global.profile.user.userId) {
        tabs.add(Tab(
              text: m.nick,
            ));
      }
    }
    return tabs;
  }

  List<ObjectiveListPage> _tabViews(List<Member> members) {
    List<ObjectiveListPage> tabs = List();
    tabs.add(ObjectiveListPage(Global.profile.user.userId));
    for(Member m in members) {
      if(m.userId != Global.profile.user.userId) {
        tabs.add(ObjectiveListPage(m.userId));
      }
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('家庭目标'),
        bottom: new TabBar(
          tabs: _tabs(Global.profile.members),
          controller: _tabController,
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add),
            label: Text('新建目标'),
            onPressed: (){
              Routers.router.navigateTo(context, Routers.newObjectivePage);
            },
          )
        ],
      ),
      
      body: new TabBarView(
        controller: _tabController,
          children: listViews,
        ),

      //floatingActionButton: _buildCreateObjectiveButton(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        
    );
  }
  /*
  Widget _buildCreateObjectiveButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(80),
      child: RaisedButton(
        child: Text(
          '新建目标',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          
        },
      ),
    );
  }*/


}
