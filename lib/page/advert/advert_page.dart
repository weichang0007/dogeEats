import 'package:carousel_slider/carousel_slider.dart';
import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

part 'advert_carousel.dart';
part 'advert_favorite.dart';

class AdvertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
