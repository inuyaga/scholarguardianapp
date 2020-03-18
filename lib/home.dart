import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:scholarguardian/pages/pageprofile.dart';

import 'pages/pageEvent.dart';
import 'pages/pageLocation.dart';
import 'pages/pagePay.dart';
import 'pages/pagealumno.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
    );
  }
  
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 4;
  final PageAlumno alumno = PageAlumno();
  final PageEvent alumnEvent = PageEvent();
  final PageLocation location = PageLocation();
  final PagePay paystatus = PagePay();
  final PageProfile profile = PageProfile();
  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget _showPage = PageProfile();
  Widget _pageChooser(int page){
    switch (page) {
      case 0:
      return alumno;
      break;
      
      case 1:
      return alumnEvent;
      break;

      case 2:
      return location;
      break;

      case 3:
      return paystatus;
      break;

      case 4:
        return profile;        
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: pageIndex,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.person_add, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.location_on, size: 30),
            Icon(Icons.credit_card, size: 30),
            Icon(Icons.settings, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.greenAccent[200],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _showPage = _pageChooser(index);
            });
          },
        ),
        body: Container(
          decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.greenAccent])),
          child: Center(
            child: _showPage
          ),
        ));
  }
}