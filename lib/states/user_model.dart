import 'package:my_family/common/global.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/models/user.dart';
import 'package:my_family/states/profile_model.dart';

class UserModel extends ProfileChangeNotifier {
  User get user => Global.profile.user;

  List<Member> get members => Global.profile.members;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null && user.token != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    Global.profile.user = user;
    notifyListeners();
  }

  set members(List<Member> members) {
    Global.profile.members = members;
    notifyListeners();
  }
}
