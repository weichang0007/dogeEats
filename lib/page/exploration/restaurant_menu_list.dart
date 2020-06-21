part of 'restaurant_page.dart';

class RestaurantMenuList extends StatefulWidget {
  final int id;
  final List products;
  final Function(dynamic value) onTap;
  const RestaurantMenuList({Key key, this.products, this.onTap, this.id})
      : super(key: key);
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
          onTap: () async {
            if (product["options"].length != 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OptionPage(product: product, id: widget.id)),
              );
              widget.onTap(null);
            } else
              widget.onTap(product["id"]);
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
