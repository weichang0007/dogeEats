part of 'index_page.dart';

class IndexCarousel extends StatefulWidget {
  @override
  State<IndexCarousel> createState() => _IndexCarouselState();
}

class _IndexCarouselState extends State<IndexCarousel> {
  final List<NetworkImage> _images = [
    NetworkImage("https://fakeimg.pl/1001"),
    NetworkImage("https://fakeimg.pl/1002"),
    NetworkImage("https://fakeimg.pl/1003"),
  ];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    CarouselSlider slider = CarouselSlider(
      items: _images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              child: Image(image: image, fit: BoxFit.fitWidth),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 800.h,
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
      height: 800.h,
      padding: EdgeInsets.fromLTRB(0, 50.h, 0, 50.h),
      child: Stack(
        overflow: Overflow.clip,
        alignment: Alignment.center,
        children: <Widget>[
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
                                ? Color.fromRGBO(0, 0, 0, 0.9)
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
