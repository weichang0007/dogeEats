import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantMenu extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final String name;
  final String type;
  final String price;

  RestaurantMenu({
    this.url,
    this.name,
    this.type,
    this.price,
    this.width,
    this.height,
  });

  @override
  State<StatefulWidget> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
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
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 90.0,
              margin: EdgeInsets.only(left: 26.w, bottom: 10.h),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
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
                  Container(
                    margin: EdgeInsets.fromLTRB(26.w, 0, 0, 10.h),
                    alignment: Alignment.centerLeft,
                    child: Text("${widget.price}TWD ", style: _chipTextStyle),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: widget.height,
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: widget.url ??
                    "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg",
              ),
            ),
          ),
        ],
      ),
    );
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(30.w, 0.h, 30.w, 0.h),
      child: content,
    );
  }
}
