part of 'restaurant_page.dart';

class RestaurantMenuList extends StatefulWidget {
  final List products;
  const RestaurantMenuList({Key key, this.products}) : super(key: key);
  @override
  State<RestaurantMenuList> createState() => _RestaurantMenuListState();
}

class _RestaurantMenuListState extends State<RestaurantMenuList> {
  List<Widget> _item = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildItem(context);
  }

  void _buildItem(BuildContext context) {
    _item.clear();
    for (Map product in widget.products) {
      _item.add(
        InkWell(
          child: RestaurantMenu(
            url: product['image_url'],
            name: product['name'],
            type: product['description'],
            price: product['price'].toString(),
            width: 1080.w,
            height: 300.h,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OptionPage(product: product)),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _item.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(padding: EdgeInsets.all(2.w), child: _item[index]);
      },
    );
  }
}
