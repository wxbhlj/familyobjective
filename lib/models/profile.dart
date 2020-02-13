import 'package:my_family/models/member.dart';
import 'package:my_family/models/user.dart';

class Profile {
  User user;
  int theme;
  String locale;
  List<Member> members = List();

  Profile({this.user, this.theme, this.locale});

  Profile.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    theme = json['theme'];
    locale = json['locale'];
    if (json['members'] != null) {
      members = new List<Member>();
      json['members'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['theme'] = this.theme;
    data['locale'] = this.locale;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}