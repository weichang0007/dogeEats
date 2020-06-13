import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'exploration_list.dart';


class ExplorationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
            IndexSearch(),
          ],
      ),
    );
  }
}
