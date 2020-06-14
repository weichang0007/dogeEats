import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:dogeeats/widget/restaurant_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'restaurant_menu_list.dart';


class RestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.blue,
              height: 1000.h,
              margin: EdgeInsets.fromLTRB(26.w, 20.h, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text("TEXT"),
            ),
            IndexMenu(),
          ],
        ),
      ),
    );
  }
}
