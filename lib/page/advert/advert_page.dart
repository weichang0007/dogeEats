import 'package:carousel_slider/carousel_slider.dart';
import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'advert_carousel.dart';
part 'advert_favorite.dart';

class AdvertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IndexCarousel(),
            IndexFavorite(),
          ],
        ),
      ),
    );
  }
}
