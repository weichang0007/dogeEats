import 'package:dogeeats/widget/restaurant_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'options_list.dart';

class OptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String picURL =
        "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000";
    return Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: false,
                  backgroundColor: Colors.black12,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Image.network(
                        picURL,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )
                  ),
                ),

              ];
            },
            body:OptionMenu(),
          ),

        ));
  }
}