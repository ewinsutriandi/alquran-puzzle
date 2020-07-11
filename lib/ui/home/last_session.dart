import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastSession extends StatefulWidget {
  final Color _bgColor = Colors.teal[50];
  final TextStyle _captionStyle = TextStyle(
    color: Colors.teal[700],    
    fontSize: 14.0,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500
  );
  final TextStyle suraNameStyle = TextStyle(
    color: Colors.teal[800],
    fontSize: 32.0,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w500
  );

  final TextStyle suraTrStyle = TextStyle(
    color: Colors.teal[700],
    fontSize: 14.0,
    letterSpacing: 1,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400
  );

  final TextStyle cntStyle = TextStyle(
    color: Colors.teal[600],
    fontSize: 16.0,
    letterSpacing: 1.1,
    fontWeight: FontWeight.w500
  );

  @override
  State<StatefulWidget> createState() => LastSessionState();
  
}

class LastSessionState extends State<LastSession> {
  String lastSura;
  String lastCorrectAya;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: widget._bgColor,                
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child:           
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _suraTitle(),
              SizedBox(
                width: 24
              ),
              Expanded(
                //child: _suraTitle(),
                child: _suraProgress(),
              )
              
            ],
          )        
    );
  }

  Widget _suraTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8,),
        Text('الْمُؤْمِنُوْنَ',style: widget.suraNameStyle,),
        Text('Al Mu\'minun',style: widget.suraTrStyle,),
      ],
    );
  }

  Widget _suraProgress() {
    return Column(      
      crossAxisAlignment: CrossAxisAlignment.end,      
      children: <Widget>[        
        SizedBox(
          height: 8,
        ),
        Text('Posisi',style: widget.cntStyle,),
        Text('Ayat ke-127 dari 118',style: widget.cntStyle,),
        _openSura(),
      ],
    );
  }

  Widget _openSura() {
    return Container(
      padding: EdgeInsets.only(top: 2),            
      alignment: Alignment.bottomRight,                        
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          ),
        onPressed: () {}, 
        child:Text('Lanjutkan',style: TextStyle(color: Colors.teal[800]),),
        color: Colors.grey[100],
      ),            
    );
  }

}