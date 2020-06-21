import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';

part 'options_list.dart';

class OptionPage extends StatelessWidget {
  final Map product;
  const OptionPage({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String picURL = product['image_url'] ??
        "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg";
    return Scaffold(
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
          body: OptionMenu(product: product),
        ),
      ),
    );
  }
}
