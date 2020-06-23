import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dogeeats/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantCard extends StatefulWidget {
  final int id;
  final String url;
  final double width;
  final double height;
  final String name;
  final String description;
  final String time;
  final String star;
  final String price;
  final String address;
  final int responseCount;
  final bool isLiked;
  final Function(bool) onLikeChenged;

  RestaurantCard({
    @required this.id,
    @required this.url,
    @required this.name,
    @required this.address,
    @required this.description,
    @required this.time,
    @required this.star,
    @required this.responseCount,
    @required this.price,
    @required this.width,
    @required this.height,
    @required this.isLiked,
    @required this.onLikeChenged,
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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: widget.height / 1.8,
            child: FadeInImage.memoryNetwork(
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: widget.url,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.w, 20.h, 26.w, 0),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.name, style: _titleStyle),
                _buildFavoriteIconButton(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.w, 0, 0, 10.h),
            alignment: Alignment.centerLeft,
            child: Text(widget.description, style: _subTitleStyle),
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
          Padding(padding: EdgeInsets.all(10.h)),
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

  Widget _buildFavoriteIconButton() {
    return LikeButton(
      isLiked: widget.isLiked,
      size: 60.sp,
      circleColor:
          CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? Colors.pink : Colors.grey,
          size: 60.sp,
        );
      },
      onTap: (bool isLiked) async {
        try {
          String baseUrl = HttpService.baseUrl;
          HttpService http = HttpService.instance;
          Response r;
          if (!isLiked)
            r = await (http
                .postEmpty("$baseUrl/restaurant/${widget.id}/favorite"));
          else
            r = await (http
                .deleteEmpty("$baseUrl/restaurant/${widget.id}/favorite"));
          Map jsonData = json.decode(r.data);
          if (jsonData['message'] != "success") throw Exception();
        } catch (e) {
          return isLiked;
        }
        isLiked = !isLiked;
        if (widget.onLikeChenged != null) widget.onLikeChenged(isLiked);
        return isLiked;
      },
    );
  }
}
