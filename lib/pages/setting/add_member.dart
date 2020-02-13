import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_family/common/global.dart';
import 'package:my_family/common/global_event.dart';
import 'package:my_family/common/http_util.dart';
import 'package:my_family/common/utils.dart';
import 'package:my_family/models/member.dart';
import 'package:my_family/widgets/dialog.dart';
import 'package:my_family/widgets/input.dart';

class AddMemeberPage extends StatelessWidget {

  final String memberId;
  AddMemeberPage(this.memberId);

  final TextEditingController _roleController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController _nickController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  String familyRole;
  final List<String> roles = List();

  @override
  Widget build(BuildContext context) {
    roles.clear();
    roles.addAll(Utils.rolenames());
    if(memberId != '0' && _roleController.text == '') {
      List<Member> members = Global.profile.members;
      for(Member m in members) {
        if(m.userId == int.parse(memberId)) {
          _roleController.value = TextEditingValue(text: Utils.roleToRolename(m.familyRole));
          _nickController.value = TextEditingValue(text: m.nick);
        }
      }
    } 

    return Scaffold(
      appBar: AppBar(
        title: Text(memberId == '0'?'添加家庭成员':'修改家庭成员'),
        actions: <Widget>[
          _buildFloatingActionButtion(context),
          _buildActionButtion(context),
          
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildInputFamilyRole(context),
            _buildInputNick(),
            Container(
              width: ScreenUtil().setWidth(710),
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                '',
                style: TextStyle(color: Colors.black45),
              ),
            ),

          ],
        ),
      ),
    );
  }
Widget _buildFloatingActionButtion(context) {
    if(memberId == '0') {
      return Container();
    }
    return FlatButton.icon(
      onPressed: () async {
        showConfirmDialog(context, '确认要删除吗', (){
          HttpUtil.getInstance()
            .delete("/api/v1/ums/user/" + memberId,)
            .then((val) {
          print(val);
          if (val['code'] == '10000') {
            GlobalEventBus.fireMemberChanged();
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(
                msg: val['message'], gravity: ToastGravity.CENTER);
          }
        });
        });
      },
      //backgroundColor: Colors.green,
      label: Text('删除'),
      icon: Icon(Icons.delete,),
    );
  }
  Widget _buildActionButtion(context) {
    return FlatButton.icon(
      icon: Icon(Icons.save),
      label: Text('保存'),
      onPressed: () {
        String familyRole = Utils.rolenameToRole(_roleController.text);
        String nick = _nickController.text;

        if (nick.length < 1) {
          Fluttertoast.showToast(msg: '请输入昵称', gravity: ToastGravity.CENTER);
          return;
        }

        var formData = {
          "familyRole": familyRole,
          "userId": Global.profile.user.userId,
          "memberId":memberId,
          "nick": nick,
          "familyId": Global.profile.user.familyId
        };
        print(formData);
        HttpUtil.getInstance()
            .post("/api/v1/ums/user/updateMember", formData: formData)
            .then((val) {
          print(val);
          if (val['code'] == '10000') {
            GlobalEventBus.fireMemberChanged();
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(
                msg: val['message'], gravity: ToastGravity.CENTER);
          }
        });
      },
    );
  }

  Widget _buildInputFamilyRole(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Stack(
        alignment: Alignment(1, 1),
        children: <Widget>[
          buildInputWithTitle(_roleController, '成员角色', '选择角色', () {
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
          buildInputWithTitle(_nickController, '成员昵称', '家庭称谓', (){}),
          buildClearButton(_nickController),
        ],
      ),
    );
  }

}
