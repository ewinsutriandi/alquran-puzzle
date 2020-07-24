import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:juz_amma_puzzle/services/user_preferences.dart';

class Hello extends StatefulWidget {
  final TextStyle helloStyle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400);

  final TextStyle nameStyle =
      TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500);

  @override
  HelloState createState() => HelloState();
}

class HelloState extends State<Hello> {
  String userName;
  TextEditingController _c;

  @override
  initState() {
    _c = TextEditingController();
    super.initState();
  }

  Widget build(BuildContext context) {
    //userName = UserPreferences().userName;
    return Row(
      children: <Widget>[
        Expanded(
          child: _greeting(),
        ),
        IconButton(
          icon: Icon(Icons.person_outline),
          color: Colors.black87,
          tooltip: 'Setting',
          onPressed: () => showDialog(
              child: new Dialog(
                  insetPadding: EdgeInsets.all(16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new TextField(
                          decoration: new InputDecoration(
                              hintText: "Masukkan nama anda"),
                          controller: _c,
                        ),
                        new FlatButton(
                          child: new Text("Simpan"),
                          onPressed: () {
                            UserPreferences().saveUserName(_c.text);
                            setState(() {});
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  )),
              context: context),
        )
      ],
    );
  }

  Widget _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Assalamu\'alaikum',
          style: widget.helloStyle,
        ),
        FutureBuilder(
          future: UserPreferences().userName,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String userName = snapshot.data;
              _c.text = userName;
              return Text(
                userName,
                style: widget.nameStyle,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
