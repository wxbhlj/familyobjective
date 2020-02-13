import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/routers.dart';
import 'package:my_family/common/utils.dart';
import 'package:my_family/models/user.dart';
import 'package:my_family/states/user_model.dart';
import 'package:my_family/widgets/input.dart';

import 'package:provider/provider.dart';

class InitSettingPage extends StatefulWidget {
  @override
  _InitSettingPageState createState() => _InitSettingPageState();
}

class _InitSettingPageState extends State<InitSettingPage> {
  final TextEditingController _roleController =
      TextEditingController.fromValue(TextEditingValue(text: '丈夫'));
  final TextEditingController _nickController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController _ptnController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController _childrenController =
      TextEditingController.fromValue(TextEditingValue(text: '一个娃'));
  final List<String> roles = List();
  final List<String> children = List();
  int iChildren = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    roles.clear();
    roles.add("丈夫");
    roles.add("妻子");
    children.clear();
    children.add('还没有');
    children.add('一个娃');
    children.add('两个娃');
    children.add('三个娃');
    children.add('四个娃');
    ScreenUtil.init(context, width: 750, height: 1334);
    return Scaffold(
      appBar: AppBar(
        title: Text('完善家庭信息'),
        actions: <Widget>[
          _buildFloatingActionButtion(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildInputFamilyRole(context),
            _buildInputNick(),
            _buildInputAccount(),
            _buildInputChildren(context)
          ],
        ),
      ),
    );
  }

  Widget _buildInputFamilyRole(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          buildInputWithTitle(_roleController, '我的角色', '', () {
            FocusScope.of(context).requestFocus(new FocusNode());

            Picker picker = new Picker(
                adapter: PickerDataAdapter<String>(pickerdata: roles),
                changeToFirst: true,
                cancelText: '取消',
                confirmText: '确定',
                height: ScreenUtil().setHeight(350),
                textAlign: TextAlign.left,
                columnPadding: const EdgeInsets.all(8.0),
                onConfirm: (Picker picker, List value) {
                  var v = value[0];
                  _roleController.value = TextEditingValue(text: roles[v]);

                  print(_roleController.value);
                });
            picker.showModal(context);
          }),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black26,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInputNick() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          buildInputWithTitle(_nickController, '我的昵称', '', null),
          buildClearButton(_nickController),
        ],
      ),
    );
  }

  Widget _buildInputAccount() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          buildInputWithTitle(_ptnController, '配偶手机', 'TA可以用此号码登陆使用', null),
          buildClearButton(_ptnController),
        ],
      ),
    );
  }

  Widget _buildInputChildren(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          buildInputWithTitle(_childrenController, '孩子数量', '', () {
            FocusScope.of(context).requestFocus(new FocusNode());

            Picker picker = new Picker(
                adapter: PickerDataAdapter<String>(pickerdata: children),
                changeToFirst: true,
                cancelText: '取消',
                confirmText: '确定',
                height: ScreenUtil().setHeight(350),
                textAlign: TextAlign.left,
                columnPadding: const EdgeInsets.all(8.0),
                onConfirm: (Picker picker, List value) {
                  iChildren = value[0];
                  _childrenController.value =
                      TextEditingValue(text: children[iChildren]);

                  print(_childrenController.value);
                });
            picker.showModal(context);
          }),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black26,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtion(context) {
    return FlatButton.icon(
      icon: Icon(Icons.save),
      label: Text('保存'),
      onPressed: () {
        String familyRole = _roleController.text == '丈夫'?'HUSBAND':'WIFE';
        String nick = _nickController.text;
        String ptn = _ptnController.text;
        if (nick.length < 1) {
          Fluttertoast.showToast(msg: '请输入昵称', gravity: ToastGravity.CENTER);
          return;
        }
        if (!Utils.isPhoneNumber(ptn)) {
          Fluttertoast.showToast(msg: '请输入正确的手机号码', gravity: ToastGravity.CENTER);
          return;
        }

        var formData = {
          "familyRole": familyRole,
          "userId": Global.profile.user.userId,
          "mobile":ptn,
          "nick":nick,
          "children":iChildren
        };
        HttpUtil.getInstance()
            .put("/api/v1/ums/user/initFamily", formData: formData)
            .then((val) {
          print(val);
          if (val['code'] == '10000') {
            User user = Global.profile.user;
            user.familyRole = val['data']['familyRole'];
            user.nick = val['data']['nick'];
            Provider.of<UserModel>(context, listen: false).user = user;

            Routers.router.navigateTo(context, Routers.homePage, replace: true);
          } else {
            Fluttertoast.showToast(
                msg: val['message'], gravity: ToastGravity.CENTER);
          }
        });
      },
    );
  }
}
