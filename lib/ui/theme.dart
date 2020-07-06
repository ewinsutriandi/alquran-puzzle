import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static final Color _bgColor = Colors.white;
  static final Color _titleColor = Colors.white;

  static ThemeData normalTheme() {
    return ThemeData(
      primarySwatch: Colors.orange,
      scaffoldBackgroundColor: _bgColor,
      brightness: Brightness.light,
        primaryColor: Colors.orange,
        accentColor: Colors.orangeAccent,
        textTheme: TextTheme(
          
        ),
    );
  }

  static AppBar appBar() {    
    return AppBar(
      title: Text('Al Qu\'ran Puzzle v0.99',style: appBarTitleStyle(),),
      centerTitle: true,
      //backgroundColor: _bgColor,              
      //elevation: 0,
    );
  }

  static TextStyle appBarTitleStyle() {
    return new TextStyle(
      color: _titleColor,
      fontSize: 16.0,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w500
    );
  }

  static Widget bottomBar() {
    Color fgColor = Colors.white;
    Color barColor = Colors.orange; 
    return CurvedNavigationBar (
      color: barColor,      
      backgroundColor: fgColor,
      height: 50,
      buttonBackgroundColor: Colors.deepOrange,
      animationDuration: Duration(milliseconds: 250),
      
      items: <Widget>[
        Icon(Icons.home, color:fgColor),
        Icon(Icons.help, color:fgColor),
        Icon(Icons.settings, color:fgColor),
        Icon(Icons.share, color:fgColor),
      ],
      onTap: (index) {
        print(index);
      },
    );
  }  

} 

class AppRouteTransition extends PageRouteBuilder {
  final Widget toPage;
  AppRouteTransition({this.toPage}) 
    : super(
      pageBuilder: (context, animation, secondaryAnimation) => toPage,
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return  SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
    );
}

