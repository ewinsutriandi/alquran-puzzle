import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Hello extends StatelessWidget {
  final String userName;
  Hello(this.userName);

  final TextStyle helloStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400
  );

  final TextStyle nameStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500
  );
  
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(child: _greeting(),),
      _appSetting()
    ],);
  }

  Widget _appSetting() {
    return IconButton(
      icon: Icon(Icons.person_outline),
      color: Colors.black87,
      tooltip: 'Setting',
      onPressed: () {
        print('pressed');
      },
    );
  }

  Widget _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Assalamu\'alaikum',style: helloStyle,),
        Text(userName,style: nameStyle,),
      ],
    );
  }

}

