class User {
  String avatar;
  String familyAvatar;
  int familyId;
  String familyName;
  String nick;
  String token;
  String familyRole;
  int userId;

  User(
      {this.avatar,
      this.familyAvatar,
      this.familyId,
      this.familyName,
      this.nick,
      this.token,
      this.userId,
      this.familyRole});

  User.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    familyAvatar = json['familyAvatar'];
    familyId = json['familyId'];
    familyName = json['familyName'];
    nick = json['nick'];
    token = json['token'];
    userId = json['userId'];
    familyRole = json['familyRole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['familyAvatar'] = this.familyAvatar;
    data['familyId'] = this.familyId;
    data['familyName'] = this.familyName;
    data['nick'] = this.nick;
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['familyRole'] = this.familyRole;
    return data;
  }
}
