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
      name: "雞老爺1號餐",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺2號餐",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺3號餐",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺4號餐",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺5號餐",
      type: "\$.美式美食",
      price: "30",
      width: 1080.w,
      height: 300.h,
    ),
    RestaurantMenu(
      url:
      "https://images.deliveryhero.io/image/fd-tw/LH/f7mo-hero.jpg?width=4000&height=1000",
      name: "雞老爺6號餐",
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

          if (index < _item.length) {

          return Padding(
              padding: EdgeInsets.all(2.w),
              child:InkWell(
                child:_item[index],
                onTap: () {
                  Navigator.pushNamed(context, "/option");
                },
              ),
          );
          }
          else{
            return Padding(
                padding: EdgeInsets.only(bottom: 50.h),
            );
          }
        },
      ),
    );
  }
}