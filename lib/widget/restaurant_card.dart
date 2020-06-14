import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCard extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final String name;
  final String type;
  final String time;
  final String star;
  final String price;
  final int responseCount;

  RestaurantCard({
    this.url,
    this.name,
    this.type,
    this.time,
    this.star,
    this.responseCount,
    this.price,
    this.width,
    this.height,
  });

  @override
  State<StatefulWidget> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  final _titleStyle = TextStyle(
    color: Colors.black,
    fontSize: 48.sp,
    fontWeight: FontWeight.bold,
  );
  final _subTitleStyle = TextStyle(
    color: Colors.grey[400],
    fontSize: 30.sp,
  );
  final _chipTextStyle = TextStyle(
    color: Colors.grey[600],
    fontSize: 26.sp,
  );

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height / 1.8,
            child: Image.network(widget.url, fit: BoxFit.cover),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.w, 20.h, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(widget.name, style: _titleStyle),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.w, 0, 0, 10.h),
            alignment: Alignment.centerLeft,
            child: Text(widget.type, style: _subTitleStyle),
          ),
          Transform(
            transform: Matrix4.identity()..scale(0.9),
            child: Container(
              height: 80.h,
              margin: EdgeInsets.only(left: 26.w, bottom: 10.h),
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    labelPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    label: Text("${widget.time} 分鐘", style: _chipTextStyle),
                    labelStyle: TextStyle(color: Colors.black54),
                    backgroundColor: Colors.grey[200],
                  ),
                  Padding(padding: EdgeInsets.only(left: 30.w)),
                  Chip(
                    labelPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    label: Row(
                      children: <Widget>[
                        Text("${widget.star}", style: _chipTextStyle),
                        Icon(Icons.star,
                            color: Colors.yellow[700], size: 40.sp),
                        Text(
                            widget.responseCount >= 100
                                ? "(100+)"
                                : "(${widget.responseCount.toString()})",
                            style: _chipTextStyle),
                      ],
                    ),
                    labelStyle: TextStyle(color: Colors.black54),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ),
          Transform(
            transform: Matrix4.identity()..scale(0.9),
            child: Container(
              margin: EdgeInsets.only(left: 26.w),
              alignment: Alignment.topLeft,
              child: Chip(
                labelPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                label: Text("${widget.price} TWD 費用", style: _chipTextStyle),
                labelStyle: TextStyle(color: Colors.black54),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(192, 192, 192, 0.125),
            blurRadius: 20.sp,
            spreadRadius: 10.w,
          ),
        ],
      ),
      margin: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 30.h),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }
}
