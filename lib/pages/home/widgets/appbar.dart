import 'package:flutter/material.dart';
import 'package:my_econnect/models/user.dart';

import 'disconnect.dart';

class Appbar extends StatelessWidget with PreferredSizeWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
            toolbarHeight: 100,
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            title: Container(
              margin: EdgeInsets.only(left: 20),
              child: Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
            ),
            actions: [Disconnect()],
            centerTitle: false,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
