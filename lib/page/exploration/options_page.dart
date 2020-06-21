import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:dogeeats/service/http_service.dart';

part 'options_list.dart';

class OptionPage extends StatefulWidget {
  final int id;
  final Map product;
  const OptionPage({Key key, this.product, this.id}) : super(key: key);
  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  HttpService _http = HttpService.instance;
  final String _baseUrl = HttpService.baseUrl;

  void _addCount() {
    widget.product["count"]++;
  }

  void _subCount() {
    if (widget.product["count"] > 1) widget.product["count"]--;
  }

  void _addProductToCart(radioButton, checkBox) async {
    try {
      List options = [];
      for (Map radio in radioButton) {
        options.add({
          "id": radio['option_id'],
          "options": [radio['value']]
        });
      }
      for (Map check in checkBox) {
        if (check['value'] == true) {
          try {
            Map o =
                options.firstWhere((item) => item['id'] == check['option_id']);
            o['options'].add(check['id']);
          } catch (e) {
            options.add({
              "id": check['option_id'],
              "options": [check['id']]
            });
          }
        }
      }
      Response addToCart = (await _http.postJson(
        "$_baseUrl/cart/add",
        json.encode({
          "restaurant_id": widget.id,
          "product": {
            "id": widget.product['id'],
            "options": options,
            "count": widget.product['count'],
          }
        }),
      ));
      Navigator.pop(context);
    } catch (e) {
      //Future.delayed(Duration(seconds: 3), () => _createCart());
    }
  }

  @override
  void initState() {
    widget.product["count"] = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget option = OptionMenu(product: widget.product);
    final String picURL = widget.product['image_url'] ??
        "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg";
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 140.h,
            color: Color.fromRGBO(255, 255, 255, 0.9),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _addCount();
                    });
                  },
                ),
                Text("${widget.product["count"]}"),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _subCount();
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 140.h,
            color: Colors.green,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.add_shopping_cart, color: Colors.white),
              onTap: () {
                List<Map> radioButtonPool = widget.product['_radioButtonPool'];
                List<Map> checkBoxPool = widget.product['_checkBoxPool'];
                _addProductToCart(radioButtonPool, checkBoxPool);
              },
              title: Text(
                "新增至購物車",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 500.h,
                floating: false,
                pinned: false,
                backgroundColor: Colors.black12,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: picURL,
                  ),
                ),
              ),
            ];
          },
          body: option,
        ),
      ),
    );
  }
}
