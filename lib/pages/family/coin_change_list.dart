import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/utils.dart';

class CoinChangeListPage extends StatelessWidget {
  final String memberId;
  CoinChangeListPage(this.memberId);

  @override
  Widget build(BuildContext context) {
    print("memberId = " + memberId.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('金币变动详情'),
      ),
      body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('加载中...'); //如果_calculation正在执行则提示：加载中
              default: //如果_calculation执行完毕
                if (snapshot.hasError) {
                  //若_calculation执行出现异常
                  return new Text('Error: ${snapshot.error}');
                } else {
                  return _createListView(context, snapshot);
                }
            }
          }),
    );
  }

  Future _getData() async {
    var formData = {"keyword": memberId, "page": 1, "pageSize": 20};
    print(formData);
    return HttpUtil.getInstance()
        .post("api/v1/ums/coinsChange/search", formData: formData);
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {

    print(snapshot.data['data']['list']);
    var changes = snapshot.data['data']['list'];
    return ListView.builder(
      itemBuilder: (context, index) => _itemBuilder(context, index, changes),
      itemCount: changes.length * 2,
    );
  }

  Widget _itemBuilder(BuildContext context, int index, movies) {
    if (index.isOdd) {
      return Divider();
    }
    index = index ~/ 2;
    return ListTile(
      title: Text(movies[index]['reason']),
      leading: _buildLeading(movies[index]['coins'] > 0),
      subtitle: Text(Utils.formatDate(movies[index]['created'])),
      trailing: Text(movies[index]['coins'].toString() + ".00", style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
  Widget _buildLeading(bool income) {
    if(income) {
      return Image.asset('images/add.png', width:ScreenUtil().setWidth(48), color:Colors.green);
    } else {
      return Image.asset('images/minus.png', width:ScreenUtil().setWidth(48), color:Colors.red);
    }
  }
}
