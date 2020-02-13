class Member {
  String avatar;
  String nick;
  String familyRole;
  int userId;

  Member(
      {this.avatar,
      this.nick,
      this.userId,
      this.familyRole});

  Member.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    nick = json['nick'];
    userId = json['id'];
    familyRole = json['familyRole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['nick'] = this.nick;
    data['id'] = this.userId;
    data['familyRole'] = this.familyRole;
    return data;
  }
}
