import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/routers.dart';
import 'package:my_family/common/utils.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/models/user.dart';
import 'package:my_family/states/user_model.dart';
import 'package:provider/provider.dart';
import '../widgets/input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phonecontroller =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController _pwdcontroller =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  FocusNode _pwdFocusNode = FocusNode();

  Timer _countdownTimer;
  String _codeCountdownStr = '获取验证码';
  int _countdownNum = 59;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildLogo(),
              //_buildSelectWorkshop(context),
              _buildInputAccount(),
              _buildInputPassword(),

              _buildLoginButton(context),
              Center(
                child: Text(''),
              )
            ],
          ),
        ));
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 20),
      height: ScreenUtil().setHeight(150),
      alignment: Alignment.center,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget _buildInputAccount() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          buildInput(_phonecontroller, Icons.person_outline, '手机号码', false),
          Container(
            margin: EdgeInsets.only(bottom: 0),
            child: _sendCodeButton(),
          )
        ],
      ),
    );
  }

  Widget _sendCodeButton() {
    return FlatButton(
      child: Text(
        _codeCountdownStr,
        style: TextStyle(
            color: _countdownTimer != null ? Colors.black12 : Colors.blue),
      ),
      onPressed: () {
        var ptn = _phonecontroller.text;
        if (Utils.isPhoneNumber(ptn)) {
          if (_countdownTimer == null) {
            HttpUtil.getInstance()
                .get("api/v1/auth/sendVerifyCode/" + ptn + "/myfamily")
                .then((val) {
              if (val['code'] == '10000') {
                reGetCountdown();
                FocusScope.of(context).requestFocus(_pwdFocusNode);
              } else {
                Fluttertoast.showToast(
                    msg: val['message'], gravity: ToastGravity.CENTER);
              }
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: '请输入正确的手机号码', gravity: ToastGravity.CENTER);
        }
      },
    );
  }

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '${_countdownNum--}秒后重新获取';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '${_countdownNum--}秒后重新获取';
          } else {
            _codeCountdownStr = '获取验证码';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  Widget _buildInputPassword() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          
          Row(
            children: <Widget>[
              buildIcon(Icons.lock_outline),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _pwdcontroller,
                    focusNode: _pwdFocusNode,
                    decoration: InputDecoration(hintText: '验证码'),
                    obscureText: false),
              ),
            ],
          ),
          buildClearButton(_pwdcontroller),
        ],
      ),
    );
  }

  Widget _buildLoginButton(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(100),
      child: RaisedButton(
        child: Text(
          '登录',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          var code = _pwdcontroller.text;
          if (code.length == 4) {
            var formData = {"code": code, "mobile": _phonecontroller.text};
            HttpUtil.getInstance()
                .post("api/v1/auth/login", formData: formData)
                .then((val) {
              print(val);
              if (val['code'] == '10000') {
                List<Member> list = new List<Member>();
                val['data']['familyMembers'].forEach((v) {
                  Member member = Member.fromJson(v);
                  list.add(member);
                });
                Provider.of<UserModel>(context, listen: false).members = list;

                User user = User.fromJson(val['data']);
                Provider.of<UserModel>(context, listen: false).user = user;
                if (user.familyRole == null || user.familyRole.length < 2) {
                  //未设置家庭信息
                  Routers.router.navigateTo(context, Routers.initSettingPage,
                      replace: true);
                } else {
                  Routers.router
                      .navigateTo(context, Routers.homePage, replace: true);
                }
              } else {
                Fluttertoast.showToast(
                    msg: val['message'], gravity: ToastGravity.CENTER);
              }
            });
          } else {
            Fluttertoast.showToast(
                msg: '请输入正确的验证码', gravity: ToastGravity.CENTER);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }
}
