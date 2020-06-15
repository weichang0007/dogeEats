part of 'advert_page.dart';

class IndexFavorite extends StatefulWidget {
  @override
  State<IndexFavorite> createState() => _IndexFavoriteState();
}

class _IndexFavoriteState extends State<IndexFavorite> {
  Future future;
  HttpService _http = HttpService.instance;

  @override
  Widget build(BuildContext context) => _buildFutureBuilder();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    future = getdata();
  }

  FutureBuilder<List<RestaurantCard>> _buildFutureBuilder() {
    return FutureBuilder<List<RestaurantCard>>(
      builder: (context, AsyncSnapshot<List<RestaurantCard>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
            child: CircularProgressIndicator(),
          );
        } else if (async.connectionState == ConnectionState.done) {
          if (async.hasData) {
            List<RestaurantCard> list = async.data;
            return Container(
              padding: EdgeInsets.only(left: 15.w),
              height: 900.h,
              child: RefreshIndicator(
                child: _buildListView(context, list),
                onRefresh: refresh,
              ),
            );
          }
        }
        return Container(
          height: 900.h,
          padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: <Widget>[
                Text(
                  "發生錯誤, 清稍後再試",
                  style: TextStyle(fontSize: 40.sp),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
      future: future,
    );
  }

  Widget _buildListView(BuildContext context, List<RestaurantCard> list) {
    if (list.length == 0)
      return Container(
        padding: EdgeInsets.only(top: 100.h),
        child: ListView(
          children: <Widget>[
            Text(
              "點擊餐廳愛心按鈕, 即可加入我的最愛",
              style: TextStyle(fontSize: 40.sp),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    return ListView.builder(
      primary: true,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) => list[index],
    );
  }

  Future<List<RestaurantCard>> getdata() async {
    try {
      String baseUrl = HttpService.baseUrl;
      Response response =
          await _http.getJsonData("$baseUrl/restaurant/favorites");
      List jsonList = response.data;
      if (jsonList.length == 0) return [];
      List<RestaurantCard> result = [];
      for (var item in jsonList)
        result.add(RestaurantParser.fromJson(
          json.encode(item['restaurant']),
          700.w,
          900.h,
          true,
          onLikeChecged,
        ));
      return result;
    } catch (e) {
      return null;
    }
  }

  void onLikeChecged(bool isLiked) async {
    Future.delayed(Duration(seconds: 1), refresh);
  }

  Future refresh() async {
    setState(() {
      try {
        future = getdata();
      } catch (e) {}
    });
  }
}
