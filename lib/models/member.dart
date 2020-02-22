class Member {
  String avatar;
  String nick;
  String familyRole;
  int userId;
  int coinsTotal;
  int coinsUsed;

  Member(
      {this.avatar,
      this.nick,
      this.userId,
      this.familyRole,
      this.coinsTotal,
      this.coinsUsed});

  Member.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    nick = json['nick'];
    userId = json['id'];
    familyRole = json['familyRole'];
    coinsTotal = json['coinsTotal'];
    coinsUsed = json['coinsUsed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['nick'] = this.nick;
    data['id'] = this.userId;
    data['familyRole'] = this.familyRole;
    data['coinsTotal'] = this.coinsTotal;
    data['coinsUsed'] = this.coinsUsed;
    return data;
  }
}
