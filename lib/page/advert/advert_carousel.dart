part of 'advert_page.dart';

class IndexCarousel extends StatefulWidget {
  @override
  State<IndexCarousel> createState() => _IndexCarouselState();
}

class _IndexCarouselState extends State<IndexCarousel> {
  final List<FadeInImage> _images = [
    FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      fit: BoxFit.fitWidth,
      image:
          'https://raw.githubusercontent.com/weichang0007/HW10-RWD/master/AD0.jpg',
    ),
    FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      fit: BoxFit.fitWidth,
      image:
          'https://raw.githubusercontent.com/weichang0007/HW10-RWD/master/AD1.jpg',
    ),
    FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      fit: BoxFit.fitWidth,
      image:
          'https://raw.githubusercontent.com/weichang0007/HW10-RWD/master/AD2.jpg',
    ),
  ];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    CarouselSlider slider = CarouselSlider(
      items: _images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(width: double.infinity, child: image);
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 600.h,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
        scrollDirection: Axis.horizontal,
      ),
    );
    return Container(
      height: 600.h,
      padding: EdgeInsets.fromLTRB(0, 0.h, 0, 50.h),
      child: Stack(
        overflow: Overflow.clip,
        alignment: Alignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
          slider,
          Positioned(
            bottom: 20.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images
                  .asMap()
                  .map(
                    (index, image) => MapEntry(
                      index,
                      Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 0.4)),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
