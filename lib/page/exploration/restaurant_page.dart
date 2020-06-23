import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/page/pages.dart';
import 'package:dogeeats/service/http_service.dart';
import 'package:dogeeats/widget/restaurant_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  int count = 0;
  TabController _tabController;
  Future future;
  HttpService _http = HttpService.instance;
  final String _baseUrl = HttpService.baseUrl;

  @override
  void initState() {
    _tabController = TabController(length: 0, vsync: this);
    _checkCartAndCreate();
    _checkCart();
    super.initState();
  }

  void _checkCartAndCreate() async {
    try {
      List cart = (await _http.getJsonData("$_baseUrl/cart")).data;
      if (cart.length > 0 &&
          cart[0]['restaurant_id'].toString() != widget.id.toString() &&
          cart[0]['products'].length > 0) {
        Alert(
          style: AlertStyle(isOverlayTapDismiss: false, isCloseButton: false),
          context: context,
          type: AlertType.warning,
          title: "偵測您的購物車有未結帳商品",
          desc: "我們偵測您的購物車有其他商店之未結帳商品, 須清除後才可進入本商店!",
          buttons: [
            DialogButton(
              child: Text(
                "清除",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                await _createCart();
                await _checkCart();
                Navigator.pop(context);
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "取消",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              color: Colors.grey,
            )
          ],
        ).show();
      } else if (cart.length > 0 &&
          cart[0]['restaurant_id'].toString() == widget.id.toString())
        return;
      else
        await _createCart();
    } catch (e) {
      _createCart();
    }
  }

  Future<void> _createCart() async {
    try {
      Response cart = (await _http.postJson(
        "$_baseUrl/cart",
        json.encode({"restaurant_id": widget.id.toString(), "products": []}),
      ));
      if (cart.data['message'] != "success")
        throw Exception("Create Cart Error!");
    } catch (e) {
      //Future.delayed(Duration(seconds: 3), () => _createCart());
    }
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
              bottomSheet: count > 0
                  ? Container(
                      alignment: Alignment.center,
                      height: 140.h,
                      color: Colors.green,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: ListTile(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ShoppingCartPage())),
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.shopping_cart, color: Colors.white),
                        title: Text(
                          "查看購物車",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        trailing: Text(
                          "$count",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : null,
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
                          image: map['img_url'] ??
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
      result.add(
        RestaurantMenuList(
          products: categorie['products'],
          onTap: _onItmeTapHandler,
          id: data['id'],
        ),
      );
    }
    return result;
  }

  void _onItmeTapHandler(value) {
    if (value == null) {
      _checkCart();
    } else
      _addProductToCart(value);
  }

  void _addProductToCart(id) async {
    try {
      await _http.postJson(
        "$_baseUrl/cart/add",
        json.encode({
          "restaurant_id": widget.id,
          "product": {"id": id, "options": [], "count": 1}
        }),
      );
      await _checkCart();
    } catch (e) {
      //Future.delayed(Duration(seconds: 3), () => _createCart());
    }
  }

  Future<void> _checkCart() async {
    try {
      Response cart = await _http.getJsonData("$_baseUrl/cart");
      count = 0;
      if (cart.data[0]['products'].length > 0)
        for (Map product in cart.data[0]['products']) {
          count += product['count'];
        }
      setState(() {});
    } catch (e) {
      print("Check Cart Error!");
      //Future.delayed(Duration(seconds: 3), () => _createCart());
    }
  }

  @override
  Widget build(BuildContext context) {
    _modifyAppbar(context);
    return _buildFutureBuilder(context);
  }

  Future<Map> getdata() async {
    try {
      Map restaurant =
          (await _http.getJsonData("$_baseUrl/restaurant/${widget.id}")).data;
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
