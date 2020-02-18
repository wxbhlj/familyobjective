class Objective {
  int id;
  int userId;
  int familyId;
  String title;
  int times;
  int weeks;
  int startDate;
  int endDate;
  int planTimes;
  int signTimes;
  int coins;
  int lastSignTime;
  int created;

  Objective(
      {this.id,
      this.userId,
      this.familyId,
      this.title,
      this.times,
      this.weeks,
      this.startDate,
      this.endDate,
      this.planTimes,
      this.signTimes,
      this.coins,
      this.lastSignTime,
      this.created});

  Objective.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    familyId = json['familyId'];
    title = json['title'];
    times = json['times'];
    weeks = json['weeks'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    planTimes = json['planTimes'];
    signTimes = json['signTimes'];
    coins = json['coins'];
    lastSignTime = json['lastSignTime'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['familyId'] = this.familyId;
    data['title'] = this.title;
    data['times'] = this.times;
    data['weeks'] = this.weeks;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['planTimes'] = this.planTimes;
    data['signTimes'] = this.signTimes;
    data['coins'] = this.coins;
    data['lastSignTime'] = this.lastSignTime;
    data['created'] = this.created;
    return data;
  }
}