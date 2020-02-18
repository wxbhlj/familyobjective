import 'package:event_bus/event_bus.dart';

const String EVENT_MEMBER_CHANGED = "EVENT_MEMBER_CHANGED";

const String EVENT_TOKEN_ERROR = "EVENT_TOKEN_ERROR";

const String EVENT_REFRESH_OBJECTIVELIST = "EVENT_REFRESH_OBJECTIVELIST";

class GlobalEventBus{
  EventBus event;
  factory GlobalEventBus() => _getInstance();

  static GlobalEventBus get instance => _getInstance();

  static GlobalEventBus _instance;

  GlobalEventBus._internal() {
    // 创建对象
    event = EventBus();
  }

  static GlobalEventBus _getInstance() {
    if (_instance == null) {
      _instance = GlobalEventBus._internal();
    }
    return _instance;
  }

  static void fireMemberChanged() {
    print("fire new cloud message ");
    _getInstance().event.fire(CommonEventWithType(EVENT_MEMBER_CHANGED));
  }
  static void fireTokenError() {
    print("fire new cloud message ");
    _getInstance().event.fire(CommonEventWithType(EVENT_TOKEN_ERROR));
  }
  static void fireRefreshObjectiveList(int userId) {
    print("fire new cloud message ");
    _getInstance().event.fire(CommonEventWithType(EVENT_REFRESH_OBJECTIVELIST, userId: userId));
  }
 
}

class CommonEventWithType {
  String eventType; //topic or message
  int userId;

  CommonEventWithType(this.eventType, {this.userId});
}