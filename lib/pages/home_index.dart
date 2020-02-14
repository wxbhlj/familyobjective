import 'package:flutter/material.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/models/member.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    List<Member> members = Global.profile.members;
    _tabController = new TabController(vsync: this, length: members.length == 0?1:members.length);
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

  List<Widget> _tabViews(List<Member> members) {
    List<Widget> tabs = List();
    tabs.add(Center(child: new Text('我自己')));
    for(Member m in members) {
      if(m.userId != Global.profile.user.userId) {
        tabs.add(Center(child: new Text(m.nick)));
      }
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('目标'),
        bottom: new TabBar(
          tabs: _tabs(Global.profile.members),
          controller: _tabController,
        ),
      ),
      
      body: new TabBarView(
        controller: _tabController,
          children: _tabViews(Global.profile.members),
        ),
        
    );
  }


}
