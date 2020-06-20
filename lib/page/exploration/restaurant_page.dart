import 'package:dogeeats/widget/restaurant_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'restaurant_menu_list.dart';

class RestaurantPage extends StatelessWidget {
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
            SliverPersistentHeader(

              delegate: _SliverAppBarDelegate(

                TabBar(

                  labelColor: Colors.black87,

                  unselectedLabelColor: Colors.grey,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5.0),
                      insets: EdgeInsets.symmetric(horizontal:16.0)
                  ),
                  tabs: [
                    Tab(text: "Tab 1"),
                    Tab(text: "Tab 2"),
                  ],
                ),
              ),
              pinned: false,

            ),
          ];
        },
        body:IndexMenu(),
      ),

    ));
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);


  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
