import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_family/widgets/input.dart';

class NewObjectivePage extends StatefulWidget {
  @override
  _NewObjectivePageState createState() => _NewObjectivePageState();
}

class _NewObjectivePageState extends State<NewObjectivePage> {
  final TextEditingController _titleController =
      TextEditingController.fromValue(TextEditingValue(text: ''));
  final TextEditingController _weeksController =
      TextEditingController.fromValue(TextEditingValue(text: '4'));
  var daysInWeek = 3;

  List<String> _chips = <String>['今天', '明天'];
  String startDay = '明天'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新建目标'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildInputTitle(),
            _buildInputDays(),
            _buildStartDay(),
            Center(
              child: Text(''),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _titleController,
        decoration: InputDecoration(hintText: '目标内容'),
        maxLines: 1,
      ),
    );
  }

  Widget _buildInputDays() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.calendar_today, color: Theme.of(context).accentColor),
              Text(
                ' 重复次数',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              children: <Widget>[
                Text(
                  '每周  ',
                  style: TextStyle(),
                ),
                _buildDaysInWeek(),
                Text(
                  '，持续 ',
                  style: TextStyle(),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _weeksController,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(hintText: ''),
                    maxLines: 1,
                  ),
                ),
                Text(
                  '周',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysInWeek() {
    return DropdownButton(
      value: daysInWeek,
      items: <DropdownMenuItem>[
        DropdownMenuItem(
          value: 1,
          child: Text('1次'),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('2次'),
        ),
        DropdownMenuItem(
          value: 3,
          child: Text('3次'),
        ),
        DropdownMenuItem(
          value: 4,
          child: Text('4次'),
        ),
        DropdownMenuItem(
          value: 5,
          child: Text('5次'),
        ),
        DropdownMenuItem(
          value: 6,
          child: Text('6次'),
        ),
        DropdownMenuItem(
          value: 7,
          child: Text('7次'),
        ),
      ],
      onChanged: (val) {
        setState(() {
          daysInWeek = val;
        });
      },
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 16),
      underline: Text(''),
    );
  }
  Iterable<Widget> get chipWidgets sync*{
    for(String chip in _chips) {
      yield Padding(
        padding: EdgeInsets.all(15),
        child: ChoiceChip(
          backgroundColor: Colors.black12,
          label: Text(chip),
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          labelPadding: EdgeInsets.only(left: 20, right: 20),
          onSelected: (val) {
            setState(() {
              startDay = val?chip:startDay;
            });
          },
          selectedColor: Theme.of(context).accentColor,
          selected: startDay == chip,
        ),
      );
    }
  }
  Widget _buildStartDay() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.calendar_today, color: Theme.of(context).accentColor),
              Text(
                ' 开始时间',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              children: chipWidgets.toList(),
            ),
          ),
        ],
      ),
    );
  }
}
