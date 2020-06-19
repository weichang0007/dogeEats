import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderInfoCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderInfoCardState();
}

class _OrderInfoCardState extends State<OrderInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              image:
                  "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg",
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
            child: _buildOrderState(context),
          ),
          Divider(color: Colors.black),
          _buildOrderDetail(context),
          Divider(color: Colors.black),
          _buildOrderTotal(context),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30.h),
            width: double.infinity,
            child: FlatButton(
              color: Colors.green,
              onPressed: () {},
              child: Text(
                "檢視進度",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderState(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    final subTitleStyle = TextStyle(color: Colors.grey[600], fontSize: 32.sp);
    final textAlign = TextAlign.left;
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 30.w)),
              Text("●  ", style: titleStyle.copyWith(color: Colors.green))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 30.w)),
              Text("餐點正在準備中...", style: titleStyle, textAlign: textAlign),
              Padding(padding: EdgeInsets.only(bottom: 8.w)),
              Text("OrderID #55688",
                  style: subTitleStyle, textAlign: textAlign),
              Padding(padding: EdgeInsets.only(bottom: 8.w)),
              Text("預估抵達時間 8:10pm", style: subTitleStyle, textAlign: textAlign),
              Padding(padding: EdgeInsets.only(bottom: 30.w)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(BuildContext context) {
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
            child: Text(" 1 ", style: titleStyle.copyWith(color: Colors.green)),
          ),
          Container(
            child: Text("　茶碗蒸", style: subTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTotal(BuildContext context) {
    final totalStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    final cancelStyle = TextStyle(color: Colors.red, fontSize: 32.sp);
    return Container(
      padding: EdgeInsets.only(left: 60.w, right: 30.w),
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("55688 TWD", style: totalStyle),
          FlatButton(onPressed: null, child: Text("取消訂單", style: cancelStyle))
        ],
      ),
    );
  }
}
