import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:juz_amma_puzzle/model/quran.dart';

class Recommend extends StatefulWidget {  
  @override
  State<StatefulWidget> createState() => RecommendState();  
}

class RecommendState extends State<Recommend> {
  String lastSura;
  String lastCorrectAya;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(0),
      child: Row(            
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[              
              Expanded(
                child:SingleRecommendation(bgColor: Colors.purple[50],fgColor: Colors.purple[600],))
              ,
              SizedBox(width:4),
              Expanded(
                child: SingleRecommendation(bgColor: Colors.brown[50],fgColor: Colors.brown[600],))
              ,
              SizedBox(width:4),
              Expanded(
                child: SingleRecommendation(bgColor: Colors.indigo[50],fgColor: Colors.indigo[600],),
              )            
        ]
      ),
    );
  }
}

class SingleRecommendation extends StatelessWidget {
  final Sura sura;
  final Color bgColor;
  final Color fgColor;
  SingleRecommendation({this.sura,this.bgColor,this.fgColor});
  
  @override
  Widget build(BuildContext context) {    
    return Container(      
      padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Column(        
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'الْمُؤْمِنُوْنَ',
            style: TextStyle(
              color: fgColor,    
              fontSize: 24.0,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500
            ),
          ),
          Text(
            'Al Mu\'minuun',
            style: TextStyle(
              color: fgColor,    
              fontSize: 12.0,
              letterSpacing: 1,
              fontWeight: FontWeight.w400
            ),
          ),
          ButtonTheme(
            minWidth: 50.0,
            height: 25,        
            child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),          
              child:Text('Mainkan',style: TextStyle(color: bgColor),),
              color: fgColor,
            ),
          )
        ],
      ),
    );
  }
}