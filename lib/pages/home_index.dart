import 'package:flutter/material.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/pages/objective/objective_list.dart';

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
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              GlobalEventBus.fireRefreshObjectiveList(listViews[_tabController.index].userId);
            },
          )
        ],
      ),
      
      body: new TabBarView(
        controller: _tabController,
          children: listViews,
        ),
        
    );
  }


}
