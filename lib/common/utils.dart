class Utils {
  static Map<String, String> roles = {
    "HUSBAND": '丈夫',
    "WIFE": "妻子",
    "SON": "儿子",
    "DAUGHTER": "女儿",
  };
  static bool isPhoneNumber(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  static String roleToRolename(String role) {
    return roles[role];
  }

  static String rolenameToRole(String name) {
    String ret = '';
    roles.forEach((k, v) {
      if(v == name) {
        ret = k;
      }
    });
    return ret;
  }

  static List<String> rolenames() {
    List<String> list = List();
    roles.forEach((k, v) {
      list.add(v);
    });
    return list;
  }
}
