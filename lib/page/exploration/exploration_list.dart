part of 'exploration_page.dart';

class IndexSearch extends StatefulWidget {
  @override
  State<IndexSearch> createState() => _IndexSearchState();
}

// TODO: 實作與接入我的探索
class _IndexSearchState extends State<IndexSearch> {
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
      height: 1700.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _item.length + 1,
        itemBuilder: (BuildContext context, int index){
          return index < _item.length
              ? _item[index]
              : Padding(padding: EdgeInsets.only(bottom: 140.h));
        } ,
      ),
    );
  }
}
