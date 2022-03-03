import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation(
      {Key? key, required this.parentAction, required this.currentIndex})
      : super(key: key);
  final ValueChanged<int> parentAction;
  final int currentIndex;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: BottomNavigationBar(
            selectedFontSize: 10,
            type: BottomNavigationBarType.fixed,
            currentIndex: widget.currentIndex,
            // showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (int i) {
              widget.parentAction(i);
            },
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: "ACCUEIL",
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.today),
                label: "AGENDA",
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.control_point),
                label: "NOUVEAU",
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.groups),
                label: "MES GROUPES",
              ),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.person), label: "MON COMPTE")
            ],
          ),
        ));
  }
}
