part of 'advert_page.dart';

class IndexFavorite extends StatefulWidget {
  @override
  State<IndexFavorite> createState() => _IndexFavoriteState();
}

// TODO: 實作與接入我的最愛
class _IndexFavoriteState extends State<IndexFavorite> {
  final List<RestaurantCard> _item = [
    RestaurantCard(
      url:
          "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺",
      type: "\$.美式美食",
      time: "10-20",
      star: "5.0",
      responseCount: 50,
      price: "30",
      width: 700.w,
      height: 900.h,
    ),
    RestaurantCard(
      url:
          "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺",
      type: "\$.美式美食",
      time: "40-50",
      star: "1.0",
      responseCount: 200,
      price: "30",
      width: 700.w,
      height: 900.h,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _item.length,
        itemBuilder: (BuildContext context, int index) => _item[index],
      ),
    );
  }
}
