import 'package:dogeeats/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderAllInfoCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderAllInfoCardState();
}

class _OrderAllInfoCardState extends State<OrderAllInfoCard> {
  Future future;
  HttpService _http = HttpService.instance;
  final String _baseUrl = HttpService.baseUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      future = getdata();
    } catch (e) {}
  }

  Future<List<Widget>> getdata() async {
    try {
      List<Widget> result = [];
      List orders = (await _http.getJsonData("$_baseUrl/orders")).data;
      List restaurant = (await _http.getJsonData("$_baseUrl/restaurants")).data;
      for (var order in orders) {
        int total = 0;
        List<Widget> detailWidget = [];
        for (Map detail in order['details']) {
          detailWidget.addAll([
            _buildOrderDetail(context, detail['count'].toString(),
                detail['product']['name'].toString()),
            Divider(color: Colors.grey[300]),
          ]);
          total += detail['count'] * detail['product']['price'];
        }
        Map rest = restaurant
            .firstWhere((element) => element['id'] == order['restaurant_id']);
        result.add(Container(
          margin: EdgeInsets.only(bottom: 30.h),
          padding: EdgeInsets.only(top: 50.h, left: 35.w, right: 35.w),
          color: Colors.white,
          child: Column(
            children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 300.h,
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.fitWidth,
                      placeholder: "assets/images/image_unavailable.png",
                      image: rest['img_url'] ??
                          "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg",
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                    child: _buildOrderState(context, order['status'].toString(),
                        order['id'].toString()),
                  ),
                ] +
                detailWidget +
                <Widget>[
                  _buildOrderTotal(context, total.toString()),
                ],
          ),
        ));
      }
      return result;
    } catch (e) {
      print(e.toString());
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      builder: (context, AsyncSnapshot<List<Widget>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (async.connectionState == ConnectionState.done) {
          if (async.hasData) {
            List<Widget> item = async.data;
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView(children: item),
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

  Widget _buildOrderState(BuildContext context, String state, String id) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    final subTitleStyle = TextStyle(color: Colors.grey[600], fontSize: 32.sp);
    final textAlign = TextAlign.left;
    Color colro = Colors.grey;
    String message = "";
    if (state == "0") {
      message = "餐點正在準備中...";
      colro = Colors.red[800];
    } else if (state == "1") {
      message = "等候外送員取餐...";
      colro = Colors.green[900];
    } else if (state == "2") {
      message = "等候外送員到府...";
      colro = Colors.green[900];
    } else if (state == "3") {
      colro = Colors.green;
      message = "訂單已完成";
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 30.w)),
              Shimmer.fromColors(
                baseColor: colro.withAlpha(180),
                highlightColor: colro,
                child: Text("●  ", style: titleStyle.copyWith(color: colro)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 30.w)),
              Text("$message", style: titleStyle, textAlign: textAlign),
              Padding(padding: EdgeInsets.only(bottom: 8.w)),
              Text("OrderID #$id", style: subTitleStyle, textAlign: textAlign),
              Padding(padding: EdgeInsets.only(bottom: 30.w)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(BuildContext context, String count, String name) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    final subTitleStyle = TextStyle(color: Colors.grey[800], fontSize: 32.sp);
    return Container(
      padding: EdgeInsets.only(left: 30.w),
      alignment: Alignment.bottomLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Text(" $count ",
                style: titleStyle.copyWith(color: Colors.green)),
          ),
          Container(
            child: Text("　$name", style: subTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTotal(BuildContext context, String total) {
    final totalStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    return Container(
      padding: EdgeInsets.only(left: 60.w, right: 30.w, bottom: 60.h),
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("$total TWD", style: totalStyle),
        ],
      ),
    );
  }
}
