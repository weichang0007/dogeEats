import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/page/pages.dart';
import 'package:dogeeats/parser/restaurant_parser.dart';
import 'package:dogeeats/service/http_service.dart';
import 'package:dogeeats/widget/location_app_bar.dart';
import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

part 'advert_carousel.dart';
part 'advert_favorite.dart';

class AdvertPage extends StatelessWidget {
  void _modifyAppbar(BuildContext context) {
    BlocProvider.of<AppbarBloc>(context).add(ModifyAppbarEvent(
      LocationAppBar(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _modifyAppbar(context);
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IndexCarousel(),
            Container(
              padding: EdgeInsets.only(left: 30.w),
              alignment: Alignment.centerLeft,
              child: Text(
                "您喜愛的餐廳",
                style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
              ),
            ),
            IndexFavorite(),
          ],
        ),
      ),
    );
  }
}
