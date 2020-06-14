part of 'restaurant_page.dart';

class IndexMenu extends StatefulWidget {
  @override
  State<IndexMenu> createState() => _IndexMenuState();
}

// TODO: 實作與接入我的探索
class _IndexMenuState extends State<IndexMenu> {
  final List<RestaurantMenu> _item = [
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.h,
      child:ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _item.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index < _item.length
              ? Padding(padding: EdgeInsets.all(30.w), child:_item[index])
              : Padding(padding: EdgeInsets.only(bottom: 30.h));
        },
      ),
    );
  }
}