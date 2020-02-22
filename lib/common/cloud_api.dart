

import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/models/user.dart';
import 'package:my_family/states/user_model.dart';
import 'package:provider/provider.dart';

void getListMember(context, Function fun) {
    HttpUtil.getInstance()
        .get("api/v1/ums/family/members/" +
            Global.profile.user.familyId.toString())
        .then((val) {
      if (val['code'] == '10000') {
        //members.clear();
        List<Member> list = new List<Member>();
        val['data'].forEach((v) {
          Member member = Member.fromJson(v);
          list.add(member);
          if (member.userId == Global.profile.user.userId) {
            User user = Global.profile.user;
            user.nick = member.nick;
            user.familyRole = member.familyRole;
            Provider.of<UserModel>(context, listen: false).user = user;
          }
        });
        Provider.of<UserModel>(context, listen: false).members = list;
        fun();
      } else {
        Fluttertoast.showToast(
            msg: val['message'], gravity: ToastGravity.CENTER);
      }
    });
  }