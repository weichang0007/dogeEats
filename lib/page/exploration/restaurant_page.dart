import 'dart:ui';

import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/page/pages.dart';
import 'package:dogeeats/service/http_service.dart';
import 'package:dogeeats/widget/restaurant_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

part 'restaurant_menu_list.dart';

class RestaurantPage extends StatefulWidget {
  final String id;
  const RestaurantPage({Key key, this.id}) : super(key: key);
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  Future future;
  HttpService _http = HttpService.instance;

  @override
  void initState() {
    _tabController = TabController(length: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      future = getdata();
    } catch (e) {}
  }

  void _modifyAppbar(BuildContext context) {
    BlocProvider.of<AppbarBloc>(context).add(ModifyAppbarEvent(null));
  }

  FutureBuilder<Map> _buildFutureBuilder(BuildContext context) {
    _modifyAppbar(context);
    return FutureBuilder<Map>(
      builder: (context, AsyncSnapshot<Map> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (async.connectionState == ConnectionState.done) {
          if (async.hasData) {
            Map map = async.data;
            final List<Widget> tabs = _buildTabs(context, map);
            _tabController = TabController(length: tabs.length, vsync: this);
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 500.h,
                      floating: true,
                      pinned: false,
                      centerTitle: true,
                      title: Stack(
                        children: <Widget>[
                          Text(
                            map['name'],
                            style: TextStyle(
                              fontSize: 50.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.sp,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.grey[700],
                            ),
                          ),
                          Text(
                            map['name'],
                            style: TextStyle(
                              fontSize: 50.sp,
                              letterSpacing: 4.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: FadeInImage.memoryNetwork(
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          image:
                              "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg",
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey,
                          indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(width: 5.0),
                              insets: EdgeInsets.symmetric(horizontal: 16.0)),
                          tabs: tabs,
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: _buildTabsContext(context, map),
                ),
              ),
            );
          }
        }
        final text = "發生錯誤, 清稍後再試";
        final style = TextStyle(fontSize: 40.sp);
        final align = TextAlign.center;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 800.h),
                    child: Text(text, style: style, textAlign: align)),
              ],
            ),
          ),
        );
      },
      future: future,
    );
  }

  List<Widget> _buildTabs(BuildContext context, Map data) {
    List<Widget> result = [];
    for (Map categorie in data['categories']) {
      result.add(Container(width: 300.h, child: Tab(text: categorie["name"])));
    }
    return result;
  }

  List<Widget> _buildTabsContext(BuildContext context, Map data) {
    List<Widget> result = [];
    for (Map categorie in data['categories']) {
      result.add(RestaurantMenuList(products: categorie['products']));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _modifyAppbar(context);
    return _buildFutureBuilder(context);
  }

  Future<Map> getdata() async {
    try {
      String baseUrl = HttpService.baseUrl;
      Map restaurant =
          (await _http.getJsonData("$baseUrl/restaurant/${widget.id}")).data;
      return restaurant;
    } catch (e) {
      return null;
    }
  }

  Future refresh() async {
    setState(() {
      try {
        future = getdata();
      } catch (e) {}
    });
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      Container(child: _tabBar, color: Colors.white);

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
